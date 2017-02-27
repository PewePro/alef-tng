class Api::V1::LearningObjectsController < Api::V1::BaseController

  def index
    render json: { list: LearningObject.all }, each_serializer: Api::V1::LearningObjectSerializer
  end

end
