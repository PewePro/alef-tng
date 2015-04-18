load(Rails.root.join( 'db', '', 'production.rb'))

additional_users = User.create!([
    {login: 'teacher1', role: User::ROLES[:TEACHER], first_name: 'Fero', last_name: 'Ucitelovic', password: 'teacher1', type: 'LocalUser'},
    {login: 'administrator1', role: User::ROLES[:ADMINISTRATOR], first_name: 'Lubos', last_name: 'Adminovic', password: 'administrator1', type: 'LocalUser'},
    {login: 'xpriezvisko', aisid: 12345, role: User::ROLES[:STUDENT], first_name: 'Igor', last_name: 'AISovic', password: '', type: 'LdapUser'}
])
