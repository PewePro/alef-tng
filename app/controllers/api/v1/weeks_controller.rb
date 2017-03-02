class Api::V1::WeeksController < Api::V1::BaseController

  def index
    render json: { list: Week.all }, each_serializer: Api::V1::WeekSerializer
  end

end
