class Tribune < ActiveRecord::Base
  has_many :posts
  has_many :links

  attr_accessible :cookie_name, :cookie_url, :get_url, :last_id_parameter, :name, :post_parameter, :post_url, :pwd_parameter, :user_parameter, :last_updated

  validates_uniqueness_of :name

  def backend(last=0, s=150)
    b = Tire.search(name) do
      query do
        range :id, { :from => last+1 }
      end
      sort do
        by :id, 'desc'
      end
      size s
    end
    
    b.results
  end

  def query(q, page=1, s=150)
    b = Tire.search(name) do
      query do
        string q
      end
      sort do
        by :id, 'desc'
      end
      from (page.to_i - 1) * s
      size s
    end
    logger.debug("*"*60 + b.to_json)
    b
  end

  # TODO Scheduler. Crontab, accès via controlleur?
  def refresh
    client = HTTPClient.new
    last_post = self.posts.last(:order => "p_id" )
    if last_post.nil?
      last_id = 0
    else
      last_id = last_post.p_id
    end
    query = {"#{last_id_parameter}" => last_id}

    response = Nokogiri::XML(client.get_content(get_url, query))

    response.xpath("/board/post[@id > #{last_id}]").reverse.each do |p|
      p_id = p.xpath("@id").to_s.to_i
      self.posts.build({ p_id: p.xpath("@id").to_s.to_i,
                     time: p.xpath("@time").to_s,
                     info: p.xpath("info").text,
                     login: p.xpath("login").text,
                     message: p.xpath("message")
      })

    end
    save!
    Tire.index name do
      self.refresh
    end

  end

  def refresh?
    now = Time.now
    to_be = (now - last_updated) > refresh_interval
    if to_be
      refresh
      update_attributes last_updated: now
      logger.info "Reload fini pour board #{name}"
    else
      logger.info "Pas de reload pour board #{name}"
    end
    to_be

  end

  def self.refresh_all
    Tribune.all.each do |t|
      t.refresh?
    end
  end

  # TODO gestion du remember me
  # @param [Hash] opts
  def login(opts)
    client = HTTPClient.new
    body = {
        user_parameter.to_sym => opts[:user],
        pwd_parameter.to_sym => opts[:password]
        #remember_me_parameter.to_sym => 1
    }
    head = {
        :Referer => cookie_url,
        :User_Agent => opts[:ua]
    }

    r = client.post(cookie_url, body, head)
    client.cookie_manager.cookies
  end

  # @param [Hash] opts
  def post(opts)
    client = HTTPClient.new
    body = { post_parameter: opts[:message]}
    head = {
            :Referer => post_url,
            :User-Agent => opts[:ua]}


    client.cookie_manager.parse(opts[:cookie], URI.parse(post_url))
    # client.debug_dev=File.open('http.log', File::CREAT|File::TRUNC|File::RDWR )
    res = client.post(post_url, body, head)
    refresh
  end
end
