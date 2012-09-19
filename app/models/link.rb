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
    return 1 unless to_index or self.post.archive != 0

    client = HTTPClient.new
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
        break if size > 15000000
        body << chunk
      end

      if r.status < 400
        created_at = Time.now
        Tire.index post.tribune.name do
          store href: escaped_href,
                created_at: created_at.to_s(:post_time),
                body: Base64.encode64(body.join),
                type: 'link'
        end
        update_column(:indexed, true)
      end
      update_column(:status, r.status)
    rescue HTTPClient::BadResponseError => e
      logger.debug("FAIL! "*15)
      logger.debug(e)
    ensure
      update_column(:to_index, false)
    end

  end

private
  def index_link
    logger.debug("Link after create for #{inspect} ")
    LinkWorker.perform_async(id)
  end
end
