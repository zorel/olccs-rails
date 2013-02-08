# encoding: UTF-8

class Post < ActiveRecord::Base
  belongs_to :tribune
  has_many :links

  attr_accessible :tribune, :time, :info, :login, :message, :p_id, :content, :rules
  attr_accessor :filtered, :rules

  validates_uniqueness_of :p_id, :scope => [:tribune_id]

  before_save :update_message
  after_save :update_tire

  paginates_per 150

  def search

  end

  def num_page(order = :id)
    position = Post.where("tribune_id = ? and #{order} >= ?", self.tribune.id, self.send(order)).count
    (position.to_f/150).ceil
  end

  private
  def update_message

    login = self.login.strip

    message_node = Nokogiri::XML.fragment(self.message).xpath('message')[0]

    if self.tribune.type_slip == Tribune::TYPE_SLIP_ENCODED
      content = message_node.child.text
    else
      content = message_node.inner_html
    end

    #cdata, text, autre = false, false, false
    #message_node.children.each do |n|
    #  if n.cdata?
    #    cdata = true
    #    break
    #  elsif n.text?
    #    text = true
    #  elsif n.element?
    #    autre = true
    #    break
    #  end
    #end
    #
    #begin
    #  if autre
    #    content = message_node.inner_html
    #  elsif cdata
    #    content = message_node.child.text
    #  else
    #    n = Nokogiri::XML.fragment(message_node.child.text)
    #    s = n.search("a","i","u","s","code","b","clock").size
    #    if s == 0
    #      content = message_node.child.to_s
    #    else
    #      content = message_node.child.text
    #    end
    #  end
    #rescue Exception => e
    #  content = ""
    #end

    n = Nokogiri::XML.fragment(content)
    puts n
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
    self.message = m
  end

  def update_tire
    a = self
    Tire.index self.tribune.name do
      store board: a.tribune.name,
            time: a.time,
            info: a.info.strip,
            login: a.login.strip,
            message: a.message.strip,
            id: a.p_id,
            type: 'post'
    end
  end

end
