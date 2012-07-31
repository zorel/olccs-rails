class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :provider
      t.text :uid
      t.text :olcc_cookie, :null => true

      t.timestamps
    end
  end
end
