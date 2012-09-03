class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.text :href
      t.text :status
      t.boolean :to_index, default: true
      t.boolean :previewed, default: false
      t.boolean :indexed, default: false
      t.integer :post_id

      t.timestamps
    end
  end
end
