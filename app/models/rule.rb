class Rule < ActiveRecord::Base
  belongs_to :user
  belongs_to :tribune

  attr_accessible :action, :filter, :name, :parameters, :tribune_id

  before_destroy :unregister_query
  before_save :register_query
  before_update :update_query

  private
  def unregister_query
    index = self.tribune.name
    md5 = self.user.md5
    name = self.name

    Tire.index('_percolator').refresh
    Tire.index(index) do
      unregister_percolator_query("#{md5}_#{name}")
    end
    Tire.index('_percolator').refresh
  end

  def register_query
    index = self.tribune.name
    md5 = self.user.md5
    filter = self.filter
    name = self.name

    Tire.index(index) do
      register_percolator_query("#{md5}_#{name}", :md5 => md5) { string "#{filter}"}
    end
    Tire.index('_percolator').refresh
  end

  def update_query
    index = self.tribune.name
    md5 = self.user.md5
    filter = self.filter
    name = self.name
    name_before = self.name_was

    Tire.index(index) do
      unregister_percolator_query("#{md5}_#{name_before}")
      register_percolator_query("#{md5}_#{name}", :md5 => md5) { string "#{filter}"}
    end
    Tire.index('_percolator').refresh
  end
end
