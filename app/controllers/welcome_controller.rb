class WelcomeController < ApplicationController

  protect_from_forgery :except => :postphp


  def postphp
    postdata = params[:postdata]
    cookie = params[:cookie]
    ua = params[:ua]

    tribune = Tribune.find_by_name(params[:name])

    message = postdata
    message.slice!(Regexp.new("#{tribune.post_parameter}="))
    message = message.gsub('#{plus}#','+').gsub('#{amp}#','&').gsub('#{dcomma}#',';').gsub('#{percent}#','%')

    tribune.post({message: message, cookies: cookie, ua: ua})

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

    render :xml => posts_to_xml(tribune.backend(:last => last, :size => 300, :user => current_user)[0], tribune.name)
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
        render :xml => urls_to_xml(@urls, root_url)
      }
    end
  end

  def index
    @tribunes = Tribune.all(:order => 'name asc')
  end

  def about
  end

  def help
  end

  def api
  end
end
