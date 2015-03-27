class User < ActiveRecord::Base
  devise :rememberable, :trackable

  ROLES = {
    STUDENT: :student,
    TEACHER: :teacher,
    ADMINISTRATOR: :administrator
  }

  has_many :setups_users
  has_many :user_to_lo_relations
  has_and_belongs_to_many :setups

  def self.guess_type(login)
    # try to find the user in DB (LdapUser/LocalUser) otherwise use LDAP
    u = User.where(login: login.downcase).first
    return u ? u.class.model_name.param_key.to_sym : :ldap_user
  end

end
