class LdapUser < User
  devise :ldap_authenticatable,
         :authentication_keys => [:login]

  def ldap_before_save
    self.last_name = query_ldap('sn')
    self.first_name = query_ldap('givenName')
    self.aisid = query_ldap('uisID')
    self.role = ( query_ldap('host').include?('fiit-zam')  ? ROLES[:TEACHER] : ROLES[:STUDENT] ) unless self.role == ROLES[:ADMINISTRATOR]
  end

  private

  def query_ldap(param)
    val = Devise::LDAP::Adapter.get_ldap_param(self.login, param)

    # if single value, extract it, otherwise return full array
    return (val.length == 1) ? val.first : val
  end

  # update the user from ldap after each sign in, not only when creating the record for the first time
  def self.find_for_ldap_authentication(attributes={})
    resource = super

    if resource && ::Devise.ldap_create_user && resource.valid_ldap_authentication?(attributes[:password])
      resource.ldap_before_save
      resource.save!
    end

    return resource
  end
end