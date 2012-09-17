class AddArchiveToPost < ActiveRecord::Migration
  def change
    add_column :posts, :archive, :integer, :default => 0
  end
end
