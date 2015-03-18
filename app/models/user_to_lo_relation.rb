class UserToLoRelation < ActiveRecord::Base
  belongs_to :learning_object
  belongs_to :setup
  belongs_to :user

  def self.get_basic_relations(los, user_id)
    self.
        where("learning_object_id IN (?)", los.map(&:id)).
        where("user_id = ?", user_id).
        where("type = 'UserVisitedLoRelation' OR type = 'UserCompletedLoRelation'").
        group(:learning_object_id, :type).count
  end
end