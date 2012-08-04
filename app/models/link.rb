class Link < ActiveRecord::Base
  belongs_to :post

  validates_uniqueness_of :href

  attr_accessible :indexed, :previewed, :status, :href, :post

  after_commit :index_link, :on => :create
  # TODO Faire un truc propre pour gestion asynchrone (to_index? / indexed / etc.)
  # TODO faire en sorte que la même URL ne soit pas indexée plusieurs fois

private
  def index_link
    logger.debug("Link after create for #{inspect} ")
    LinkWorker.perform_async(id)
  end
end
