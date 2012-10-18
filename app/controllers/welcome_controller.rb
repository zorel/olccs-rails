# encoding: UTF-8

# Controleur de gestion de la racine du site
class WelcomeController < ApplicationController

  protect_from_forgery :except => :postphp

  # Compatibilité olcc pour le post d'un message
  # TODO: gestion des tribunes persos non indexées
  def postphp
    postdata = params[:postdata]
    cookie = params[:cookie]
    ua = params[:ua]

    tribune = Tribune.find_by_name(params[:name])

    message = postdata
    message.slice!("#{tribune.post_parameter}=")
    message = message.gsub('#{plus}#','+').gsub('#{amp}#','&').gsub('#{dcomma}#',';').gsub('#{percent}#','%')

    tribune.post({message: message, cookies: cookie, ua: ua})

    render :text => "plop"
  end

  # Compatibilité olcc pour la demande du backend
  # TODO: gestion des tribunes persos non indexées
  def backendphp
    tribune = Tribune.find_by_name(params[:name])
    uri = URI.parse(params[:url])
    last = 0
    if uri.query && CGI.parse(uri.query)
      if CGI.parse(uri.query)['last'][0]
        last = CGI.parse(uri.query)['last'][0].to_i
      end
    end

    render :xml => posts_to_xml(tribune.backend(:last => last, :size => 300, :user => current_user)[0], tribune.name)
  end

  # Compatibilité olcc pour la recherche des totoz
  def totozphp
    url = params[:url].sub(/\{question\}/,'?').sub(/ /,'+')
    client = HTTPClient.new
    client.ssl_config.verify_mode=(OpenSSL::SSL::VERIFY_NONE)
    r = client.get(url)
    render :xml => r.body
  end

  # Compatibilité olcc pour l'upload de fichier
  # TODO: ben todo
  def attachphp

  end

  # Voir la doc d'API
  def urls
    @urls = Link.limit(42).order("created_at desc")

    respond_to do |format|
      format.rss
      format.xml {
        render :xml => urls_to_xml(@urls, root_url)
      }
    end
  end

  # Voir l'aide
  def index
    @tribunes = Tribune.all(:order => 'name asc')
  end

  def boards
    boards = Tribune.all
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.sites {
        boards.each { |b|
          xml.site(:name => b.name) {
            xml.module(:name => "board", :title => "tribune", :type => "application/board+xml") {
              xml.backend(:path => b.get_url, :public => "true", :tags_encoded => "false", :refresh => 10)
              xml.post(:method => "post", :path => b.post_url, :anonymous => "true", :max_length => 512) {
                xml.field(:name => b.post_parameter) {
                  "$m"
                }
              }
              xml.login(:method => "post", :path => b.cookie_url) {
                xml.username(:name => b.user_parameter)
                xml.password(:name => b.pwd_parameter)
                xml.remember(:name => b.remember_me_parameter)
                xml.cookie(:name => b.cookie_name)
              }
            }
          }
        }
      }
    end

    render :xml => builder.to_xml(:encoding => 'UTF-8', :save_with => Nokogiri::XML::Node::SaveOptions::AS_XML)
  end


  # Voir l'aide
  def about
  end

  def help
  end

  def api
  end
end
