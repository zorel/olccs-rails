# Modèle de gestion des URLs
class Link < ActiveRecord::Base
  belongs_to :post

  validates_uniqueness_of :href

  attr_accessible :indexed, :previewed, :status, :href, :post

  after_commit :index_link, :on => :create
  # DONE Faire un truc propre pour gestion asynchrone (to_index? / indexed / etc.)
  # DONE faire en sorte que la même URL ne soit pas indexée plusieurs fois

  # Effectue l'indexation du lien dans elasticsearch:
  # * Télécharge le fichier (15Mo max)
  # * le dépose dans ElasticSearch configuré pour indexer le contenu grace à https://github.com/elasticsearch/elasticsearch-mapper-attachments
  def index
    return 1 unless to_index
    more_than_one_year_old = Time.now - Time.strptime(post.time, '%Y%m%d%H%M%S') > 1.year

    if more_than_one_year_old
      update_column(:to_index, false)
      return 2
    end
    client = HTTPClient.new
    client.connect_timeout=10
    client.ssl_config.verify_mode=(OpenSSL::SSL::VERIFY_NONE)

    headers = [%w(Accept text/html), %w(Accept application/xhtml+xml), %w(Accept application/xml)]
    query = nil
    escaped_href = URI.escape(href)
    size = 0
    body = []
    begin
      #if %w(text/html application/xhtml+xml application/xml).include?(content_type)
      r = client.get(escaped_href, query, headers, follow_redirect: true) do |chunk|
        size += chunk.size
        raise HTTPClient::BadResponseError if size > 1500000
        body << chunk
      end

      if r.status < 400
        created_at = Time.now
        Tire.index post.tribune.name do
          store id: Digest::MD5.hexdigest(escaped_href),
                href: escaped_href,
                created_at: created_at.to_s(:post_time),
                body: Base64.encode64(body.join),
                type: 'link'
        end
        update_column(:indexed, true)

        if r.contenttype.include?("html")
          executable = File.join(Rails.root, 'script', 'preview.sh')
          string_args = "#{Digest::MD5.hexdigest(escaped_href)} #{escaped_href} #{Rails.root.to_s}"
          `#{executable} #{string_args}`
        end
      end
      update_column(:status, r.status)
    rescue HTTPClient::BadResponseError => e
      logger.debug("FAIL! "*15)
      logger.debug(e)
    end
  ensure
    update_column(:to_index, false)
  end


  def index_link
    logger.debug("Link after create for #{inspect} ")
    LinkWorker.perform_async(id)
  end
end
