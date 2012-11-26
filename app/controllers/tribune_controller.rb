# encoding: UTF-8

# Controleur de gestion de tribune, gère le multiformat xml/rss/html/json là où c'est nécessaire. Se réferer à la document
# de l'API pour les informations nécessaires
class TribuneController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  protect_from_forgery :except => [:post, :login]

  before_filter :set_tribune

  #def populate_perco
  #  redirect_to root_url if current_user.nil?
  #  user = current_user
  #  md5 = Digest::MD5.hexdigest("#{user.provider}#{user.uid}")
  #  Tire.index(@tribune.name) do
  #    register_percolator_query("#{md5}_ototu", :md5 => md5) { string 'login:ototu' }
  #  end
  #end

  # Voir la doc d'API
  def index
    #raise Rails.application.config.assets.paths.to_yaml
    last = params[:last] || -1073741824
    page = params[:page] || 1
    # size = params[:size] || 150 cf partie dans tribune.rb => param supprimé
    r = @tribune.backend(:last => last, :user => current_user, :page => page)
    @results = r[0]
    @posts = r[1]

    #raise @results.to_yaml

    respond_to do |format|
      format.html
      format.json
    end

  end

  def xmlconfig
#    <?xml version="1.0" encoding="utf-8" ?>
#        <site name="kadreg" title="Da lent bouchot" baseurl="http://kadreg.org" version="1.0" xmlns="urn:moules:board:config:1.0">
#    <account>
#    <cookie name="md5"/>
#    <cookie name="unique_id"/>
#    <login method="post" path="/login.html">
#    <field name="login">$l</field>
#<field name="passwd">$p</field>
#    </login>
#<logout method="get" path="/close_session.html"/>
#</account>
#<module type="application/board+xml" name="board" title="Tribune">
#<backend path="/board/backend.php" public="true" tags_encoded="false" refresh="60"/>
#<post method="post" path="/board/add.php" anonymous="false" max_length="128">
#<field name="message">$m</field>
#</post>
#</module>
#</site>
  end

  # Voir la doc d'API
  def remote
    last = params[:last] || 0
    page = params[:page] || 1

    @results = @tribune.backend({:last => last, :user => current_user, :page => page})[0]
    #raise @results.to_yaml
    #res = nil
    #
    #if current_user
    #  puts "percolation pour #{@current_user.name}"

    #end

    respond_to do |format|
      format.tsv
      format.xml { render xml: posts_to_xml(@results, @tribune.name) }
    end

  end

  # Voir la doc d'API
  def post
    last = params[:last] || -1073741824

    x = @tribune.post message: params[:message],
        ua: request.user_agent,
        cookies: request.cookies

    unless x.nil?
      response.headers['X-Post-Id'] = x
    end

    @results = @tribune.backend({:last => last, :user => current_user})[0]

    respond_to do |format|
      format.html { render :nothing => true}
      format.tsv { render :template => 'tribune/remote'}
      format.xml {render xml: posts_to_xml(@results, @tribune.name) }
    end

    #render :nothing => true
  end

  # Voir la doc d'API
  def search
    # TODO: pour la recherche, prévoir à l'affichage un truc pour prendre les posts des horloges pointées, et éventuellement un "contexte" en nombre de lignes affichables
    size = params[:size] || 150
    page = params[:page] || 1
    @results = []
    if params[:query].blank?
      respond_to do |format|
        format.html { render }
        format.xml { render :nothing => true}
        format.tsv { render :nothing => true}
      end
    else
      @results = @tribune.query(params[:query],page,150).results
      #raise @results.to_yaml
      respond_to do |format|
        format.html
        format.xml { render :xml => search_to_xml(@results, @tribune.name) }
        format.tsv
      end
    end

  end

  # Voir la doc d'API
  def stats
  end

  # Voir la doc d'API
  def urls
    @urls = @tribune.links.order("created_at desc").limit(42)

    respond_to do |format|
      format.html
      format.rss
      format.xml {render :xml => urls_to_xml(@urls, @tribune.name)}
    end

  end

  # Voir la doc d'API
  def login
    tribune_login = @tribune.login({user: params[:user], password: params[:password], ua: "plop"})

    tribune_login.each {|c|
      cookies[c.name] = { value: c.value, expires: c.expires }
    }
    render :json => tribune_login.to_json
  end

  # Voir la doc d'API
  def history
  end

  # Voir la doc d'API
  def refresh
    @tribune.refresh
  end

private
  def set_tribune
    @tribune = Tribune.find_by_name(params[:tribune]) || raise(ActiveRecord::RecordNotFound)
  end

  def record_not_found
    render :text => "404 Not Found", :status => 404
  end

end
