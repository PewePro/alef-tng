class FeedbackMailer < ApplicationMailer
  def new (feedback)
    @feedback = feedback
    @learning_object = LearningObject.find(feedback.learning_object_id) unless feedback.learning_object_id.nil?
    puts @learning_object
    #mail(to: 'alef@fiit.stuba.sk', subject: "[ALEF:TNG] New msg: #{@feedback.url_path}")
  end
end
