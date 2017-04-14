class UpdateValuesOfCommentNumber < ActiveRecord::Migration
  def self.up
    LearningObject.all.each do |lo|
      lo.update_attribute :comment_number, lo.feedbacks.where('visible = ?', true).count
    end
  end
end
