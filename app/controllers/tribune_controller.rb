class TribuneController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  before_filter :set_tribune

  def index

  end

  # TODO: percolater chaque post en fonction des préfs utilisateurs
  def remote
    last = params[:last] || 0
    size = params[:size] || 150

    @results = @tribune.backend(last,size)
    #res = nil
    #
    #if current_user
    #  puts "percolation pour #{@current_user.name}"
    #  md5 = Digest::MD5.hexdigest("#{@current_user.provider}#{@current_user.uid}")
    #
    #
    #  index = Tire.index(@tribune.name)
    #
    #  # TODO: a déplacer dans le modèle Tribune au niveau de la génération du backend
    #  res = @results.collect do |r|
    #    content = r['_source']
    #    #raise content['message'].to_yaml
    #    matches = index.percolate(message: content['message'], time: content['time'], login: content['login'], info: content['info'], type:'post') do
    #      term :usermd5, md5
    #    end
    #
    #    #raise matches.to_yaml
    #    if matches.include?('warning')
    #      logger.debug "ici, dans le filtre, #{content.inspect}"
    #
    #      plop = OlccsPluginsManager.instance.repository[:plopify]
    #      new_message = plop.instance.process(content['message'])
    #      content['message'] = new_message
    #      #logger.debug "ici, dans le filtre, #{content.methods.sort}"
    #      logger.debug("============> " + matches.to_s + " " + content['message'] + " --#{new_message}--")
    #      #raise content.to_yaml
    #    end
    #
    #    content
    #  end
    #end

    respond_to do |format|
      format.tsv
      format.xml { render xml: to_xml(@results) }
    end

  end

  def post

  end

  def search
    # TODO: pour la recherche, prévoir à l'affichage un truc pour prendre les posts des horloges pointées, et éventuellement un "contexte" en nombre de lignes affichables
    size = params[:size] || 150
    page = params[:page] || 1
    @results = []
    if params[:query].nil? || params[:query] == ""
      respond_to do |format|
        format.html { render }
        format.xml { render :nothing => true}
        format.tsv { render :nothing => true}
      end
    else
      @results = @tribune.query(params[:query],page,10).results
      #raise @results.to_yaml

      respond_to do |format|
        format.html
        format.xml { render :xml => to_xml(@results) }
        format.tsv
      end
    end

  end

  def stats
  end

  def urls
    @urls = @tribune.links.order("created_at desc").limit(42)

    respond_to do |format|
      format.rss
      format.xml
    end
  end

  def login
    tribune_login = @tribune.login({user: params[:user], password: params[:password], ua: "plop"})

    tribune_login.each {|c|
      cookies[c.name] = { value: c.value, expires: c.expires }
    }
    render :json => tribune_login.to_json
  end

  def history
  end

  def refresh
    @tribune.refresh
  end

private
  def set_tribune
    @tribune = Tribune.find_by_name(params[:tribune]) || raise(ActiveRecord::RecordNotFound)
  end

  private

  def record_not_found
    render :text => "404 Not Found", :status => 404
  end

  # @param [Array] posts
  # @return [String]
  def to_xml(posts)
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.board(:site => @tribune.name) {
        posts.each { |p|
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
    builder.to_xml(:encoding => 'UTF-8', :save_with => Nokogiri::XML::Node::SaveOptions::AS_XML)
  end

end