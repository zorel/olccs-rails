class WelcomeController < ApplicationController
  def postphp
    postdata = params[:postdata]
    cookie = params[:cookie]
    ua = params[:ua]

    tribune = Tribune.find_by_name(params[:name])

    message = postdata
    message.slice!(Regexp.new("#{tribune.post_parameter}="))
    message.gsub('#{plus}#','+').gsub('#{amp}#','&').gsub('#{dcomma}#',';').gsub('#{percent}#','%')

    tribune.post({message: message, cookie: cookie, ua: ua})

    render :text => "plop"
  end

  def backendphp
    tribune = Tribune.find_by_name(params[:name])
    uri = URI.parse(params[:url])
    last = CGI.parse(uri.query) ? CGI.parse(uri.query)[tribune.last_id_parameter][0].to_i : 0

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.board(:site => tribune.name) {
        tribune.backend(last).each { |p|
          xml.post(:id => p['id'], :time => p['time']) {
            xml.info {
              xml << p['info']
            }
            xml.login {
              xml << p['login']
            }
            xml.message {
              xml << p['message']
            }
          }
        }
      }
    end
    render :xml => builder.to_xml(:encoding => 'UTF-8', :save_with => Nokogiri::XML::Node::SaveOptions::AS_XML)
  end

  def totozphp
    url = params[:url].sub(/\{question\}/,'?')
    client = HTTPClient.new
    r = client.get(url)
    render :xml => r.body
  end

  def index
    @tribunes = Tribune.all(:order => 'name asc')
  end

  def welcome
  end

  def about
  end
end
