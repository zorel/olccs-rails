class Post < ActiveRecord::Base
  belongs_to :tribune
  has_many :links

  attr_accessible :tribune, :time, :info, :login, :message, :p_id, :archive

  validates_uniqueness_of :p_id, :scope => [:tribune_id, :archive]

  before_save :update_message
  after_save :update_tire

  paginates_per 150

  scope :live, :conditions => {archive: 0}

  def search

  end

  private
  def update_message

    login = self.login.strip

    message_node = Nokogiri::XML.fragment(self.message).xpath('message')[0]
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

    begin
      content = autre ? message_node.inner_html : message_node.child.text
    rescue
      content = ""
    end

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
