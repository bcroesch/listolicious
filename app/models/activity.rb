class Activity < ActiveRecord::Base
  has_many  :list_items
  has_many  :users, :through => :list_item
  
  attr_accessible :name
end
