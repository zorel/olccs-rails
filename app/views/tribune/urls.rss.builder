xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Liste des liens pour #{@tribune.name}"
    xml.description "les 42 derniers liens postés sur #{@tribune.name}"
    xml.link url_for controller: 'tribune', tribune: @tribune.name

    for url in @urls
      xml.item do
        xml.title url.href
        xml.description "Posté par #{url.post.login.presence || url.post.info}"
        xml.pubDate url.created_at.to_s(:rfc822)
        xml.link url.href
        #xml.guid post_url(url)
      end
    end
  end
end