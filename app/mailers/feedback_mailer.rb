class FeedbackMailer < ApplicationMailer
  def new (feedback)
    @feedback = feedback
    @user = User.find(feedback.user_id)
    mail(to: 'alef@fiit.stuba.sk', subject: '[ALEF:TNG] Nový feedback')
  end
end
