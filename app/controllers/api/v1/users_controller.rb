class Api::V1::UsersController < Api::V1::BaseController

  def index
    render json: { list: User.all }, each_serializer: Api::V1::UserSerializer
  end

end
