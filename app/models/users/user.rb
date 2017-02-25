class User < ActiveRecord::Base
  devise :rememberable, :trackable

  ROLES = {
    STUDENT: :student,
    TEACHER: :teacher,
    ADMINISTRATOR: :administrator
  }

  # Generuje metody User.rola? zo zoznamu roli
  User::ROLES.values.each do |role|
    define_method("#{role}?") do
      self.role == "#{role}"
    end
  end

  has_many :setups_users
  has_many :rooms
  has_many :user_to_lo_relations
  has_many :feedbacks
  has_many :api_access_tokens
  has_and_belongs_to_many :setups

  def self.guess_type(login)
    # try to find the user in DB (LdapUser/LocalUser) otherwise use LDAP
    u = User.where(login: login.downcase).first
    return u ? u.class.model_name.param_key.to_sym : :ldap_user
  end

  def has_rooms?
    self.involved_in_gamification
  end

  # Vyhodnoti, ci ide o doveryhodneho pouzivatela (administrator alebo ucitel).
  def verified?
    administrator? || teacher?
  end

  # Vytvori cele meno pouzivatela.
  def full_name
    first_name + ' ' + last_name
  end

  # Vygeneruje privatny kluc (pre API).
  def generate_private_key!
    loop do
      private_key = SecureRandom.hex(32)
      next if User.find_by(private_key: private_key)
      update!(private_key: private_key)
      break
    end

    private_key
  end

  # Vygeneruje pristupovy token (pre API).
  def generate_access_token!
    token = nil
    loop do
      token = SecureRandom.hex(50)
      next if ApiAccessToken.find_by(token: token)
      ApiAccessToken.create!(user: self, token: token, expires_at: Time.now + 1.week)
      break
    end

    token
  end

end
