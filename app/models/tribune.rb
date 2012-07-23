class Tribune < ActiveRecord::Base
  has_many :posts
  has_many :links

  attr_accessible :cookie_name, :cookie_url, :get_url, :last_id_parameter, :name, :post_parameter, :post_url, :pwd_parameter, :user_parameter

  validates_uniqueness_of :name

  def backend(last=0, s=150)
    b = Tire.search(name) do
      query do
        range :id, { :from => last }
      end
      sort do
        by :id, 'desc'
      end
      size s
    end
    
    return b.results
  end

  def query(q, s=150)
    b = Tire.search(name) do
      query do
        string q
      end
      sort do
        by :id, 'desc'
      end
      size s
    end

    return b.results
  end
  def refresh
    client = HTTPClient.new
    last_post = Post.last(:order => "p_id")
    if last_post.nil?
      last_id = 0
    else
      last_id = last_post.p_id
    end
    query = {"#{last_id_parameter}" => last_id}

    response = Nokogiri::XML(client.get_content(get_url, query))

    response.xpath("/board/post[@id > #{last_id}]").reverse.each do |p|
      p_id = p.xpath("@id").to_s.to_i
      puts p.xpath("message").inspect
      self.posts.build({ p_id: p.xpath("@id").to_s.to_i,
                     time: p.xpath("@time").to_s,
                     info: p.xpath("info").text,
                     login: p.xpath("login").text,
                     message: p.xpath("message")
      })

    end
    save
    Tire.index name do
      self.refresh
    end

  end

  def post(m)
    url = post_url
    c = m.gsub('#{plus}#','+').gsub('#{amp}#','&').gsub('#{dcomma}#',';').gsub('#{percent}#','%')
    i = c.index("=") || -1

    body = { post_parameter.to_sym => c}
    head = {
            "Referer" => post_url,
            "Cookie"  => opts[:cookies],
            "User-Agent" => opts[:ua]}

    client = HTTPClient.new
    client.post(post_url, body, head)
    refresh
  end
end
