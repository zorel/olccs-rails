class Tribune < ActiveRecord::Base
  has_many :posts
  has_many :links, :through => :posts

  attr_accessible :cookie_name, :cookie_url, :get_url, :last_id_parameter, :name, :post_parameter, :post_url, :pwd_parameter, :user_parameter, :last_updated, :remember_me_parameter, :refresh_interval

  validates_uniqueness_of :name

  #TODO Faire un chargement par fichier remote.xml afin de charger un historique
  #TODO Faire un chargement via bdd pour historique khapin

  def backend(last=0, s=150)
    b = Tire.search(name) do
      query do
        range :id, {:from => last.to_i+1}
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
    logger.debug(b.to_json)
    b
  end

  def refresh
    client = HTTPClient.new
    last_post = self.posts.last(:order => "p_id")
    if last_post.nil?
      last_id = 0
    else
      last_id = last_post.p_id
    end
    query = {"#{last_id_parameter}" => last_id}

    begin
      r = client.get(get_url, query)

      #puts "*"*80
      #puts "#{name} => " + r.content.force_encoding('utf-8').encoding.to_s
      #puts "#{name} => " + r.body_encoding.to_s
      #puts "*"*80
      response = Nokogiri::XML(r.content)
      response.xpath("/board/post[@id > #{last_id}]").reverse.each do |p|
        p_id = p.xpath("@id").to_s.to_i
        self.posts.build({p_id: p.xpath("@id").to_s.to_i,
                          time: p.xpath("@time").to_s,
                          info: p.xpath("info").text.encode('utf-8').strip,
                          login: p.xpath("login").text.encode('utf-8').strip,
                          message: p.xpath("message")
                         })

      end
      save!
      Tire.index name do
        self.refresh
      end
    rescue HTTPClient::BadResponseError => e
      logger.error ("Refresh failed for #{name}")
      logger.error (e)
    ensure
      update_column :last_updated, Time.now
    end
  end

  def refresh?
    RefreshWorker.perform_async(id)
  end

  def self.refresh_all
    Tribune.all.each do |t|
      t.refresh?
    end
  end

  # @param [Hash] opts
  def login(opts)
    client = HTTPClient.new
    body = {
        user_parameter.to_sym => opts[:user],
        pwd_parameter.to_sym => opts[:password],
        remember_me_parameter.to_sym => 1
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
    body = {post_parameter.to_sym => opts[:message]}
    head = {
        :Referer => post_url,
        "User-Agent" => opts[:ua]}

    client.cookie_manager.parse(opts[:cookie], URI.parse(post_url)) unless opts[:cookie].nil?
    #client.debug_dev=File.open('http.log', File::CREAT|File::TRUNC|File::RDWR )
    begin
      res = client.post(post_url, body, head)
    rescue Exception => e
      logger.error("Post fail for #{name}")
      logger.error(e)
    else
      self.refresh
    end
  end
end
#
#http%3A//euromussels.eu/%3Fq%3Dtribune/post&postdata=message=test
#http%3A//euromussels.eu/%3Fq%3Dtribune/post&postdata=message=123
#ua=onlineCoinCoin/0.4.2&name=euromussels&cookie=&posturl=
#
#            ua=[:zorel]&name=euromussels&cookie=&posturl=http%3A//euromussels.eu/%3Fq%3Dtribune/post&postdata=message=test
#ua=onlineCoinCoin/0.4.2&name=euromussels&cookie=&posturl=http%3A//euromussels.eu/%3Fq%3Dtribune/post&postdata=message=123