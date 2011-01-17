class CreateShares < ActiveRecord::Migration
  def self.up
    create_table :shares do |t|
      t.integer :user_id
      t.string :service
      t.text :content
      t.integer :shareable_id
      t.string :shareable_type

      t.timestamps
    end
  end

  def self.down
    drop_table :shares
  end
end
