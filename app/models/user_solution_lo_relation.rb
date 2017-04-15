class UserSolutionLoRelation < ActiveRecord::Base
  belongs_to :answer
  belongs_to :user_to_lo_relations_user_to_lo_relation, :class_name => 'UserToLoRelations::UserToLoRelation'

end