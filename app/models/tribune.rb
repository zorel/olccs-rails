# encoding: UTF-8

# Modèle de représentation de tribune. Effectue toutes les interractions avec la tribune cible et présente aux
# modèles et controlleurs utilisateurs une API standard quelque soit la tribune.
class Tribune < ActiveRecord::Base
  has_many :posts
  has_many :links, :through => :posts
  has_many :rules

  attr_accessible :cookie_name, :cookie_url, :get_url, :last_id_parameter, :name, :post_parameter, :post_url,
                  :pwd_parameter, :user_parameter, :last_updated, :remember_me_parameter, :refresh_interval, :type_slip

  validates_uniqueness_of :name

  TYPE_SLIP_RAW = 0
  TYPE_SLIP_ENCODED = 1

  # TODO Faire un chargement par fichier remote.xml afin de charger un historique

  # Génère le backend pour la tribune. Si un utilisateur est connecté, on effectué également une percolation de chacun
  # des posts du backend pour lancer les actions dessus.
  # @param [Hash] opts
  def backend(opts={})
    # s supprimé de la liste: utilisation de la pagination avec du per_page de kaminari
    conf = {
        :last => -1073741824,
        :user => nil,
        :page => 1,
    }.merge(opts)
    # TODO ça merde avec la pagination, le p_id > 0 certainement
    b = self.posts.page(conf[:page]).where("p_id > ?", conf[:last]).order("p_id DESC")

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

    return [b.to_a, b] if conf[:user].nil? or conf[:user].rules.size == 0

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

  # Effectue une recherche dans Elasticsearch pour la tribune
  # TODO: refaire cette partie pour options en hash
  def query(q, page=1, s=150)
    b = Tire.search(name) do
      query do
        string q, default_operator: "AND", default_field: "message"
      end
      highlight :message, :options => { :tag => '<span class="label">' }
      sort do
        by :id, 'desc'
      end
      from (page.to_i - 1) * s
      size s.to_i
    end
    #logger.debug(b.to_json)

  end

  # Effectue le rafraichissement de la tribune
  #
  # * Lance la requête vers la tribune cible avec le last id positionné
  # * Filtre le contenu avec Nokogiri pour (au cas où la tribune n'accepte pas le last id)
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

  # Lance le refresh conditionnel sur toutes les tribunes
  def self.refresh_all
    Tribune.all.each do |t|
      t.refresh?
    end
  end

  # Permet le login sur la tribune cible par envoie du login/mdp vers le formulaire de login, et retourne les cookies
  #
  # TODO: mettre à jour la partie sur les cookies pour renvoyer ce que plopoid accepte
  # @param [Hash<user,password>] opts Paramètre contenant nom d'utilisateur et mot de passe
  # @return [Hash] Renvoie le hash de cookies
  def login(opts)
    client = HTTPClient.new
    client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE

    body = {
        user_parameter.to_sym => opts[:user],
        pwd_parameter.to_sym => opts[:password],
        'form_id' => 'user_login_block'
    }
    body[remember_me_parameter.to_sym] = 1 unless remember_me_parameter.nil?
    head = {
        :Referer => cookie_url,
        :User_Agent => opts[:ua]
    }

    r = client.post(cookie_url, body, head)
    client.cookie_manager.cookies
  end

  # Poste un nouveau message sur la tribune cible
  #
  # TODO: refaire la partie sur les cookies
  # @param [Hash<message, ua, cookies>] opts Hash de paramètre
  # @return [Integer] Renvoie le X-Post-Id du post (nil si la tribune ne renvoie pas de X-Post-Id)
  def post(opts)

    client = HTTPClient.new
    body = {
        post_parameter.to_sym => opts[:message]
    }
    head = {
        :Referer => post_url,
        "User-Agent" => opts[:ua]
    }

    unless opts[:cookies].nil? and opts[:cookies]==''
      if opts[:cookies].class == String
        client.cookie_manager.parse(opts[:cookies], URI.parse(post_url))
      elsif opts[:cookies].class == Hash
        opts[:cookies].each do |k, v|
          if v != ""
            c = "#{k}=#{v.encode('utf-8')}"
            client.cookie_manager.parse(c, URI.parse(post_url))
          end
        end
      end
    end

    res = client.post(post_url, body, head)

    self.refresh

    return res.headers['X-Post-Id']

  rescue Exception => e
    logger.error("Post fail for #{name}")
    logger.error(opts)
    logger.error(e)
    logger.error(e.backtrace)
  end

  # Chargement en masse de posts dans la base
  #
  # Charge chaque csv dans une transaction pour optimiser les temps de traitement
  #
  # Liste des champs dans le CSV: post_id, time (format YYYYMMDDhhmmss), login, info/ua, message
  #
  # Dans phpmyadmin, faire un export format csv pour excel.
  # @param [String] directory Chemin où sont situés les fichiers .csv

  #def load_from_csv(directory)
  #  cpt = 0
  #  coder = HTMLEntities.new # pour vieux posts dlfp
  #  # sed -i.bak 's/"N,//' *.csv
  #
  #  Dir.glob(directory+'/*.csv') do |filename|
  #    puts "Gestion de #{filename} à #{Time.now}"
  #    #transaction do
  #      CSV.foreach(filename, {:col_sep => ','}) do |r|
  #        cpt+=1
  #        puts r[0].to_i
  #        # pour ancien site dlfp
  #        p_id = r[0].to_i - 3050553
  #        id = p_id
  #        time = Time.strptime(r[1], '%Y-%m-%d %H:%M:%S').strftime('%Y%m%d%H%M%S')
  #        login = r[2] || ""
  #        info = r[3] || ""
  #        # pour dlfp. Sinon, supprimer le decode
  #        message = coder.decode(r[4]) || ""
  #
  #        self.posts.build({p_id: p_id,
  #                          time: time,
  #                          info: info.encode('utf-8').strip,
  #                          login: login.encode('utf-8').strip,
  #                          message: "<message>#{message.encode('utf-8').strip}</message>"
  #                         })
  #      end
  #    #end
  #    save!
  #    puts "#{filename} terminé à #{Time.now}"
  #    File.rename(filename, "#{filename}.done")
  #  end
  #
  #rescue Exception => e
  #  puts e
  #  puts e.backtrace
  #end
end
