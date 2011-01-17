class User < ActiveRecord::Base
  has_many :lists, :dependent => :destroy
  has_many :list_items
  has_many :activities, :through => :list_items
  has_many :authentications
  
  after_create :create_bucket_list
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  def full_name
    return self.email if self.first_name.nil? && self.last_name.nil?
    return (self.first_name || "") + " " + (self.last_name || "")
  end
  
  def create_bucket_list
    self.lists.create(:name => "Bucket List")    
  end
  
  def apply_omniauth(omniauth)
     self.email = omniauth['extra']['user_hash']['email'] if email.blank?
     self.first_name = omniauth['user_info']['first_name']
     self.last_name = omniauth['user_info']['last_name']
     self.fb_access_token = omniauth["credentials"]["token"]
     authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
   end

   def password_required?
     (authentications.empty? || !password.blank?) && super
   end
   
   def fb_id
      self.authentications.authentications.where(:provider => "facebook").first.uid
   end
end
