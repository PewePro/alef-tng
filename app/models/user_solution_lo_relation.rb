class UserSolutionLoRelation < ActiveRecord::Base
  belongs_to :answer
  belongs_to :user_to_lo_relation

end