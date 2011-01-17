class AddFbAccessToken < ActiveRecord::Migration
  def self.up
    add_column :authentications, :fb_access_token, :string
  end

  def self.down
    remove_column :authentications, :fb_access_token
  end
end
