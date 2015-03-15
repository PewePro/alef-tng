class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable,
         :confirmable,
	       :registerable,
         :recoverable, 
	       :rememberable,
	       :trackable,
	       :validatable


  #validates :login, format: { with: /\A[A-Za-z0-9_]+\z/ }, presence: true, uniqueness: { case_sensitive: false }

  has_many :setups_users
  has_many :user_to_lo_relations
  has_and_belongs_to_many :setups

  def self.create_without_confirmation!(attributes)
    user = User.new(attributes)

    user.skip_confirmation!
    user.save!
    user
  end

end
