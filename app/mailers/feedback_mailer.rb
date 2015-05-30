class FeedbackMailer < ApplicationMailer
  def new(feedback)
    @feedback = feedback
    unless feedback.learning_object_id.nil?
      @learning_object = LearningObject.find(feedback.learning_object_id)

      unless @learning_object.image.nil?
        attachments['image.png'] = {mime_type: 'image/png',
                                  content: @learning_object.image}
      end
    end
    mail(to: 'alef@fiit.stuba.sk', subject: "[ALEF:TNG] New msg: #{@feedback.url_path}")
  end
end
