class FeedbackMailer < ApplicationMailer
  def new (feedback)
    @feedback = feedback
    mail(to: 'alef@fiit.stuba.sk', subject: "[ALEF:TNG] New msg: #{@feedback.url_path}")
  end
end
