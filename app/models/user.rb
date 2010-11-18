class User < ActiveRecord::Base
  has_many :lists, :dependent => :destroy
  has_many :list_items
  has_many :activities, :through => :list_items
  
  after_create :create_bucket_list
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :oauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  def create_bucket_list
    self.lists.create(:name => "Bucket List")    
  end
  
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
      # Get the user email info from Facebook for sign up
      # You'll have to figure this part out from the json you get back
      data = ActiveSupport::JSON.decode(access_token)

      if user = User.find_by_email(data["email"])
        user
      else
        # Create an user with a stub password.
        User.create!(:name => data["name"], :email => data["email"], :password => Devise.friendly_token)
      end
    end
end
