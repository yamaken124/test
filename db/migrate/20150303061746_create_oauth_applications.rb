class CreateOauthApplications < ActiveRecord::Migration
  def change
    create_table :oauth_applications do |t|
      t.string :name, default: '', null: false
      t.string :consumer_key, default: '', null: false
      t.string :consumer_secret, default: '', null: false
      t.text :redirect_uri

      t.timestamps null: false
    end
  end
end
