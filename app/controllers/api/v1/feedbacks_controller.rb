class Api::V1::FeedbacksController < Api::V1::BaseController

  def index
    render json: Feedback.all, each_serializer: Api::V1::FeedbackSerializer
  end

end
