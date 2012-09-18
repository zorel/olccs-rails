# encoding: UTF-8

class Tribune < ActiveRecord::Base
  has_many :posts
  has_many :links, :through => :posts
  has_many :rules

  attr_accessible :cookie_name, :cookie_url, :get_url, :last_id_parameter, :name, :post_parameter, :post_url, :pwd_parameter, :user_parameter, :last_updated, :remember_me_parameter, :refresh_interval

  validates_uniqueness_of :name

  #TODO Faire un chargement par fichier remote.xml afin de charger un historique
  #TODO Faire un chargement via bdd pour historique khapin

  # @param [Hash] opts
  def backend(opts={})
    # s supprimé de la liste: utilisation de la pagination avec du per_page de kaminari
    conf = {
        :last => 0,
        :user => nil,
        :page => 1,
    }.merge(opts)

    b = self.posts.live.page(conf[:page]).where("p_id > ?", conf[:last]).order("p_id DESC")

    #b = Tire.search(name) do
    #  query do
    #    range :id, {:from => last.to_i+1}
    #  end
    #  sort do
    #    by :id, 'desc'
    #  end
    #  size s
    #end

    #r = b.results.results.collect do |i|
    #  i['_source']
    #end

    return [b.to_a, b] if conf[:user].nil?

    logger.debug("On commence la percolation")
    md5 = conf[:user].md5

    index = Tire.index(name)

    res = b.collect do |content|
      #raise content['message'].to_yaml
      matches = index.percolate(message: content.message, time: content.time, login: content.login, info: content.info, type: 'post') do
        term :md5, md5
      end

      #raise matches.to_yaml
      unless matches.nil?
        matched = []
        matches.each do |m|
          rule_name = m.split('_')[1]
          rule = conf[:user].rules.find_by_name(rule_name)

          action = rule.action.to_sym
          #raise rule.to_yaml
          logger.debug "ici, dans le filtre, #{content.inspect} pour #{rule_name}"
          plop = OlccsPluginsManager.instance.repository[action]
          unless plop.nil?
            new_message = plop.instance.process(content['message'])
            content['message'] = new_message
            matched << action
          end
        end
        content['rules'] = matched.join(',')
      end
      content
    end
    #raise res.to_yaml
    [res, b]
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
    #logger.debug(b.to_json)
    b
  end

  def refresh
    client = HTTPClient.new
    last_post = self.posts.live.last(:order => "p_id")
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
    body = {
        post_parameter.to_sym => opts[:message]
    }
    head = {
        :Referer => post_url,
        "User-Agent" => opts[:ua]
    }

    unless opts[:cookies].nil? opts[:cookies]==''
      opts[:cookies].each do |k, v|
        if v != ""
          c = "#{k}=#{v.encode('utf-8')}"
          client.cookie_manager.parse(c, URI.parse(post_url))
        end
      end
    end

    res = client.post(post_url, body, head)

    self.refresh

    return res.headers['X-Post-Id']

  rescue Exception => e
    logger.error("Post fail for #{name}")
    logger.error(opts)
    logger.error(e.backtrace)
  end

  def load_from_csv(directory)
    cpt = 0
    Dir.glob(directory+'/*.csv') do |filename|
      puts "Gestion de #{filename} à #{Time.now}"
      transaction do
        CSV.foreach(filename, {:col_sep => ';'}) do |r|
          cpt+=1
          p_id = r[1].to_i
          time = Time.strptime(r[2], '%Y-%m-%d %H:%M:%S').strftime('%Y%m%d%H%M%S')
          login = r[3] || ""
          info = r[4] || ""
          message = r[5] || ""

          archive = p_id > 1507459 ? 1 : 0

          self.posts.build({p_id: p_id,
                            time: time,
                            info: info.encode('utf-8').strip,
                            login: login.encode('utf-8').strip,
                            message: "<message>#{message.encode('utf-8').strip}</message>",
                            archive: archive
                           })
          puts "#{cpt}" if (cpt % 1000 == 0)
        end
        save!
      end
      puts "#{filename} terminé à #{Time.now}"
      File.rename(filename, "#{filename}.done")

    end
  end
end
