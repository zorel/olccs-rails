# Controleur racine
class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :posts_to_xml, :urls_to_xml

private
  # Sélection de l'utilisateur en fonction de la session.
  def current_user
    begin
      @current_user = User.find(session[:user_id])
    rescue Exception => e
      @current_user = nil
    end
  end

  # Conversion d'un timestamp
  # @param [String] time Le timestamp format YYYYMMDDhhmmss
  # @return [String] Le timestamp format hh:mm:ss
  def time_to_horloge(time)
    Time.strptime(time, '%Y%m%d%H%M%S').strftime('%H:%M:%S')
  end

  # Convertion d'un timestamp
  # @param [String] time Le timestamp format YYYYMMDDhhmmss
  # @return [String] Le timestamp format DD/MM#hh:mm:ss
  def time_to_full_horloge(time)
    Time.strptime(time, '%Y%m%d%H%M%S').strftime('%d/%m#%H:%M:%S')
  end

  # Génération du remote à partir d'une liste de posts
  # @param [Array] posts Le tableau de {Post}
  # @param [String] site Le nom du site à générer dans le tag board
  def posts_to_xml(posts, site)
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.board(:site => site) {
        posts.each { |p|
          xml.post(:id => p.p_id, :time => p.time, :board => p.tribune.name) {
            xml.info {
              xml << p.info
            }
            xml.login {
              xml << p.login
            }
            xml.message {
              xml << p.message
            }
          }
        }
      }
    end
    builder.to_xml(:encoding => 'UTF-8', :save_with => Nokogiri::XML::Node::SaveOptions::AS_XML)
  end

  # Génération du remote à partir d'une liste de la recherche
  # @param [Array] posts Le tableau de {Post}
  # @param [String] site Le nom du site à générer dans le tag board
  def search_to_xml(res, site)
    posts = res.to_a
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.board(:site => site) {
        posts.each { |p|
          p = p['_source']
          xml.post(:id => p['id'], :time => p['time'], :board => p['board']) {
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
