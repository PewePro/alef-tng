class LdapUser < User
  devise :ldap_authenticatable,
         :authentication_keys => [:login]

  def ldap_before_save
    ldap_entry = Devise::LDAP::Adapter.get_ldap_entry(self.login)

    # sadly, Net::LDAP::Entry doesn't have #map
    entry = {}
    ldap_entry.each do |param|
      x = ldap_entry[param]
      entry[param] = (x.length == 1 ? x.first : x)
    end

    self.last_name = entry[:sn]
    self.first_name = entry[:givenname] # 'givenName' before symbol lowercasing
    self.aisid = entry[:uisid]          # 'uisID' before symbol lowercasing
    unless self.role == ROLES[:ADMINISTRATOR]
      self.role = ( entry[:host].include?('fiit-zam') ? ROLES[:TEACHER] : ROLES[:STUDENT] )
    end

    mails = extract_ldap_mails(entry[:mail])
    self.email = mails[:email]
    self.ais_email = mails[:ais_email]
  end

  private

  # update the user from ldap after each sign in, not only when creating the record for the first time
  def self.find_for_ldap_authentication(attributes={})
    resource = super

    if resource && ::Devise.ldap_create_user && resource.valid_ldap_authentication?(attributes[:password])
      resource.ldap_before_save
      resource.save!
    end

    return resource
  end

  # 'mail' entry FOR A SINGLE USER can look like this (in any order):
  #    name.surname@stuba.sk, 2007123456@is.stuba.sk, 2007123456@stuba.sk, xloginn@stuba.sk, xloginn@is.stuba.sk, name.surname@is.stuba.sk, 67890@stuba.sk, 67890@is.stuba.sk
  # extract first non-numeric @stuba.sk and @is.stuba.sk address
  LDAP_EMAIL = /^[a-z].*@stuba.sk$/
  LDAP_AIS_EMAIL = /^[a-z].*@is.stuba.sk$/
  def extract_ldap_mails(mails)
    return {email: mails, ais_email: mails} if mails.is_a? String

    email = mails.find {|x| LDAP_EMAIL =~ x }
    ais_email = mails.find {|x| LDAP_AIS_EMAIL =~ x }

    return {email: email, ais_email: ais_email}
  end
end