class LinkWorker
  include Sidekiq::Worker

  def perform(link_id)

    link = Link.find(link_id)
    puts ("Sidekiq job for #{link.inspect}")
    client = HTTPClient.new
    client.ssl_config.verify_mode=(OpenSSL::SSL::VERIFY_NONE)

    headers = [%w(Accept text/html), %w(Accept application/xhtml+xml), %w(Accept application/xml)]
    query = nil
    href = URI.escape(link.href)

    begin
      #if %w(text/html application/xhtml+xml application/xml).include?(content_type)
      r = client.get(href, query, headers, follow_redirect: true)

      if r.status < 400
        href = link.href
        created_at = Time.now
        Tire.index link.post.tribune.name do
          store href: href,
                created_at: link.post.time,
                body: Base64.encode64(r.body),
                type: 'link'
        end
        link.update_attributes({indexed: true, status: r.status})
      end
    rescue HTTPClient::BadResponseError => e
      link.logger.debug("FAIL! "*15)
      link.logger.debug(e)
    end
  end
end