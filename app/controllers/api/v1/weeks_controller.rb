class Api::V1::WeeksController < Api::V1::BaseController

  def index
    render json: Week.all, each_serializer: Api::V1::WeekSerializer
  end

end
