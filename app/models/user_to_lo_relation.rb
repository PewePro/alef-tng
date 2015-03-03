class UserToLoRelation < ActiveRecord::Base
  belongs_to :learning_object
  belongs_to :setup
  belongs_to :user
end