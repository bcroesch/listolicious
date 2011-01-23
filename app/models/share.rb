class Share < ActiveRecord::Base
  belongs_to :shareable, :polymorphic => true
  
  attr_accessible :service, :content, :shareable_id, :shareable_type
end
