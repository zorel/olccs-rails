class AddTribuneToRule < ActiveRecord::Migration
  def change
    add_column :rules, :tribune_id, :integer
  end
end
