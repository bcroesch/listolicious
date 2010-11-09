class User < ActiveRecord::Base
  has_many :lists
  has_many :list_items
  has_many :activities, :through => :list_items
  
  after_create :create_bucket_list
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  def create_bucket_list
    self.lists.create(:name => "Bucket List")    
  end
end
