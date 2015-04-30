class FeedbackMailer < ApplicationMailer
  def new (feedback)
    @feedback = feedback
    unless feedback.learning_object_id.nil?
      @learning_object = LearningObject.find(feedback.learning_object_id)
    end
    mail(to: 'matus.pikuliak@gmail.com', subject: "[ALEF:TNG] New msg: #{@feedback.url_path}")
  end
end
