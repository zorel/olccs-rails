class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.text :name
      t.text :filter
      t.text :action
      t.text :parameters
      t.integer :user_id
      #t.integer :tribune_id

      t.timestamps
    end
  end
end
