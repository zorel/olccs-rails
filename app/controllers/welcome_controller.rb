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
    last = 0
    if uri.query && CGI.parse(uri.query)
      if CGI.parse(uri.query)[tribune.last_id_parameter][0]
        last = CGI.parse(uri.query)[tribune.last_id_parameter][0].to_i
      end
    end

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.board(:site => tribune.name) {
        tribune.backend(last).each { |p|
          content = p['_source']
          xml.post(:id => content['id'], :time => content['time']) {
            xml.info {
              xml << content['info']
            }
            xml.login {
              xml << content['login']
            }
            xml.message {
              xml << content['message']
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

  def urls
    @urls = Link.limit(42).order("created_at desc")

    respond_to do |format|
      format.rss
      format.xml {
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.board(:site => root_url) {
            @urls.each { |u|
              xml.post(:id => u.id, :time => u.post.time) {
                xml.info {
                  xml << u.post.info
                }
                xml.login {
                  xml << u.post.login
                }
                xml.message {
                  xml << "Sur #{u.post.tribune.name}: <a href='#{u.href}'>#{u.href}</a>"
                }
              }
            }
          }
        end
        render :xml => builder.to_xml(:encoding => 'UTF-8', :save_with => Nokogiri::XML::Node::SaveOptions::AS_XML)
      }
    end
  end

  def index
    @tribunes = Tribune.all(:order => 'name asc')
  end

  def welcome
  end

  def about
  end

  # @param [Array] posts
  # @return [String]
  def to_xml(posts)
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.board(:site => @tribune.name) {
        posts.each { |p|
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
    builder.to_xml(:encoding => 'UTF-8', :save_with => Nokogiri::XML::Node::SaveOptions::AS_XML)
  end
end
