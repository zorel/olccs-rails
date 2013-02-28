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

  def self.test(m, type)
    message="<message><![CDATA[test=&amp;plop;]]></message>"
    logger.debug(message)
    message_node = Nokogiri::XML.fragment(message).xpath('message')[0]

    if type==1
      #content = message_node.child.nil? ? '' : message_node.child.text
      cdata = false
      message_node.children.each do |n|
        if n.cdata?
          cdata = true
          break
        end
      end
      if cdata
        content = message_node.child.text
      else
        t = message_node.child.text.gsub(/&/, '&amp;')
        logger.debug("text => #{message_node.child.text}")
        logger.debug("t => #{t}")
        content = Nokogiri::XML.fragment(t).inner_html
      end
    else
      content = message_node.inner_html
    end
    logger.debug "Content after typeslip detection ==> #{content} <=="

    n = Nokogiri::XML.fragment(content)

    #n.search('clock').each do |t|
    #  t.add_previous_sibling(t.inner_text)
    #  t.remove
    #end
    logger.debug "Content after clock sanitize ==> #{n.inspect} <=="
    logger.debug "Content after clock sanitize ==> #{n.to_xml} <=="

    #n.search('a').each do |t|
    #  if t['class'] != 'smiley'
    #    self.links.build({href: t['href']})
    #  end
    #end
    m = n.to_xml(:encoding => 'UTF-8', save_with: Nokogiri::XML::Node::SaveOptions::AS_XML).strip
    logger.debug "=> #{m} <="
  rescue Exception => e
    logger.error('Truc fail for post')
    logger.error(e.message)
    logger.error(e.backtrace)
  end

  private
  def update_message
    login = self.login.strip

    message_node = Nokogiri::XML.fragment(self.message).xpath('message')[0]

    if self.tribune.type_slip == Tribune::TYPE_SLIP_ENCODED
      cdata = false
      message_node.children.each do |n|
        if n.cdata?
          cdata = true
          break
        end
      end
      if cdata
        content = message_node.child.text
      else
        t = message_node.child.text.gsub(/&/, '&amp;')
        logger.debug("text => #{message_node.child.text}")
        logger.debug("t => #{t}")
        content = Nokogiri::XML.fragment(t).inner_html
      end
    else
      content = message_node.inner_html
    end
    logger.debug "Content after typeslip detection ==> #{content} <=="

    n = Nokogiri::XML.fragment(content)

    n.search('clock').each do |t|
      t.add_previous_sibling(t.inner_text)
      t.remove
    end
    logger.debug "Content after clock sanitize ==> #{n.to_xml} <=="

    n.search('a').each do |t|
      if t['class'] != 'smiley'
        self.links.build({href: t['href']})
      end
    end
    m = n.to_xml(:encoding => 'UTF-8', save_with: Nokogiri::XML::Node::SaveOptions::AS_XML).strip
    self.message = m
  rescue Exception => e
    logger.error('Truc fail for post')
    logger.error(e.message)
    logger.error(e.backtrace)
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
