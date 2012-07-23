class LinkObserver < ActiveRecord::Observer

  # @param [Link] link
  def after_create(link)
    client = HTTPClient.new
    client.ssl_config.verify_mode=(OpenSSL::SSL::VERIFY_NONE)

    headers = [%w(Accept text/html), %w(Accept application/xhtml+xml), %w(Accept application/xml)]
    query = nil

    href = URI.escape(link.href)

    head = client.head(href, query, headers)
    status = head.status
    if status < 400
      link.logger.debug("URL #{href}, status #{status}")
      content_type = head ? "" : head.contenttype.split(';')[0]
      if %w(text/html application/xhtml+xml application/xml).include?(content_type)
        body = client.get_content(href, query, headers)
        href = link.href
        created_at = Time.now
        Tire.index link.post.tribune.name do
          store href: href,
                created_at: created_at,
                body: body,
                type: 'link'
        end
      end
      link.update_attributes({indexed: true, status: status})
    end
  end


end
