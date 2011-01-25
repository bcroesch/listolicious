class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :actvitiies, :user_id
    
    add_index :list_items, :user_id
    add_index :list_items, :activity_id
    add_index :list_items, :list_id
    
    add_index :lists, :user_id
    
    add_index :lists, :private
    
    add_index :authentications, :user_id
    add_index :authentications, [:provider, :uid]
  end

  def self.down
  end
end
