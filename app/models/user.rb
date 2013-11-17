class User < BaseModel
  attr_accessible
  attr_accessible :email, :password, :password_confirmation, :as => :user
  attr_accessible :email, :first_name, :last_name, :admin, :as => :admin
  has_secure_password
  
  has_many :profile_field_values
  has_many :about_us_entries
  has_many :photos
  has_many :snippets
  
  attr_accessor :email_can_be_blank
  
  validates :email, :presence => true, :if => Proc.new { |user| !user.email_can_be_blank }
  
  validates :email,
            :allow_blank => true,
            :uniqueness => true,
            :format => /^([a-z0-9\-_]+\.?)+@([a-z0-9\-]+\.)+[a-z]{2,9}$/i
            
  validates :password,
            :length => { :minimum => 6 },
            :if => :password_digest_changed?
            
  validates_presence_of :first_name, :last_name
  
  def self.student
    where(student: true)
  end
  
  def self.ordered_by_name
    order(:last_name, :first_name)
  end
  
  def full_name
    self.first_name + " " + self.last_name
  end
  
  def admin?
    !!self.admin
  end
  
  def set_random_password
    self.password = self.class.random_hash
  end
  
  def set_activation_code
    self.activation_code = self.class.random_hash
  end
  
  def activate
    self.activation_code = nil
  end
  
  def logged_in
    self.last_login = Time.zone.now
  end
  
  def reset_password
    self.set_random_password
    self.set_activation_code
  end
  
  private
  
  def self.random_hash
    SecureRandom.hex
  end
end
