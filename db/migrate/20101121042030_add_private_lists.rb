class AddPrivateLists < ActiveRecord::Migration
  def self.up
    add_column :lists, :private, :boolean, :default => false
  end

  def self.down
    remove_column :lists, :private
  end
end
