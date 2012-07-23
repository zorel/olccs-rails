class Post < ActiveRecord::Base
  belongs_to :tribune
  has_many :links

  attr_accessible :tribune, :time, :info, :login, :message, :p_id

  validates_uniqueness_of :p_id, :scope => :tribune_id

  CODERS = HTMLEntities.new

  def search

  end

  before_create do |post|
    #puts "Grouin meuh, before_validation, #{post.tribune.inspect}"
    #puts "=> #{post.message} <="
    message_node = Nokogiri::XML.fragment(post.message).xpath('message')[0]
    #puts "=> #{message_node.inspect} <="
    cdata, text, autre = false, false, false
    message_node.children.each do |n|
      if n.cdata?
        cdata = true
        break
      elsif n.text?
        text = true
      elsif n.element?
        autre = true
        break
      end
    end

    content = autre ? message_node.inner_html : message_node.child.text

    n = Nokogiri::XML.fragment(content)

    n.search("clock").each do |t|
      t.add_next_sibling(t.inner_text)
      t.remove
    end
    n.search("a").each do |t|
      if t['class'] != 'smiley'
        self.links.build({href: t['href']})
      end
    end
    m = n.to_xml(:encoding => 'UTF-8', :save_with => Nokogiri::XML::Node::SaveOptions::AS_XML).strip
    post.message = m
  end

  after_save do |post|
    Tire.index post.tribune.name do
      store board: post.tribune.name,
            time: post.time,
            info: post.info.strip,
            login: post.login.strip,
            message: post.message.strip,
            id: post.p_id,
            type: 'post'
    end
  end

end
