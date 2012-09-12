class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :posts_to_xml, :urls_to_xml

private
  def current_user
    begin
      @current_user = User.find(session[:user_id])
    rescue Exception => e
      @current_user = nil
    end
  end

  def time_to_horloge(time)
    Time.strptime(time, '%Y%m%d%H%M%S').strftime('%H:%M:%S')
  end

  def time_to_full_horloge(time)
    Time.strptime(time, '%Y%m%d%H%M%S').strftime('%d/%m#%H:%M:%S')
  end

  def posts_to_xml(posts, site)
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.board(:site => site) {
        posts.each { |p|
          content = p
          xml.post(:id => content['id'], :time => content['time'], :board => content['board']) {
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
    builder.to_xml(:encoding => 'UTF-8', :save_with => Nokogiri::XML::Node::SaveOptions::AS_XML)
  end

  def urls_to_xml(urls, site)
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.board(:site => site) {
        @urls.each { |u|
          xml.post(:id => u.id, :time => u.post.time, :board => u.post.tribune.name) {
            xml.info {
              xml << u.post.info
            }
            xml.login {
              xml << u.post.login
            }
            xml.message {
              xml << "#{time_to_full_horloge(u.post.time)}@#{u.post.tribune.name}: <a href='#{u.href}'>#{u.href}</a>"
            }
          }
        }
      }
    end

    builder.to_xml(:encoding => 'UTF-8', :save_with => Nokogiri::XML::Node::SaveOptions::AS_XML)
  end

end
