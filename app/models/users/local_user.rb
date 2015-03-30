class LocalUser < User
  devise :database_authenticatable,
         :authentication_keys => [ :login ]
#         :confirmable,
#         :lockable,
#         :recoverable,
#         :registerable,
#         :validatable


end