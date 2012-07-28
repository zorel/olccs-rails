class Link < ActiveRecord::Base
  belongs_to :post

  validates_uniqueness_of :href

  attr_accessible :indexed, :previewed, :status, :href, :post

  # TODO Faire un truc propre pour gestion asynchrone (to_index? / indexed / etc.)
end
