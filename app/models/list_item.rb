class ListItem < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :list
  belongs_to  :activity
  has_many    :shares, :as => :shareable
  
  validates_presence_of     :user_id
  validates_presence_of     :list_id
  validates_presence_of     :activity_id
end
