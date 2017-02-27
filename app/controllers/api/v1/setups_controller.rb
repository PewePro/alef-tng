class Api::V1::SetupsController < Api::V1::BaseController

  def index
    render json: Setup.all, each_serializer: Api::V1::SetupSerializer
  end

end
