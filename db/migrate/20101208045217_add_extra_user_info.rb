class AddExtraUserInfo < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
  end

  def self.down
    remove_column :first_name
    remove_column :last_name
  end
end
