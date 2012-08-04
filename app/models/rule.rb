class Rule < ActiveRecord::Base
  belongs_to :user

  attr_accessible :action, :filter, :name, :parameters
end
