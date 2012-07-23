class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :p_id
      t.text :login
      t.text :info
      t.text :time
      t.text :message
      t.integer :tribune_id
    end
  end
end
