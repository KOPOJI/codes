class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_length_of :username, minimum: 4, maximum: 20
  validates_uniqueness_of :username
  
  has_one :profile

  has_many :messages
  has_many :private_messages

  after_create :create_profile
  
  def create_profile
    Profile.create user_id: self.id if Profile.find_by_user_id(self.id).nil?
    return true
  end
  
  def admin?
	  self.username == 'KOPOJI'
  end
  def online?
    updated_at > 10.minutes.ago
  end
end
