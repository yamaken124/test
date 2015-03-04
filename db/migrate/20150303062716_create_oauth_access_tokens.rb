class CreateOauthAccessTokens < ActiveRecord::Migration
  def change
    create_table :oauth_access_tokens do |t|
      t.references :user, index: true
      t.integer :oauth_application_id, null: false
      t.string :token, default: '', null: false
      t.integer :expires_in, default: 600, null: false
      t.string :scopes, default: '', null: false

      t.timestamps null: false
    end
    add_foreign_key :oauth_access_tokens, :users
    add_foreign_key :oauth_access_tokens, :oauth_applications
  end
end
