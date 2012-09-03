class CreateTribunes < ActiveRecord::Migration
  def change
    create_table :tribunes do |t|
      t.text :name
      t.text :get_url
      t.text :last_id_parameter
      t.text :post_parameter
      t.text :post_url
      t.text :cookie_url
      t.text :cookie_name
      t.text :user_parameter
      t.text :pwd_parameter
      t.text :remember_me_parameter
      t.datetime :last_updated, :default => Time.now
      t.integer :refresh_interval, :default => 15
      t.timestamps
    end
  end
end
