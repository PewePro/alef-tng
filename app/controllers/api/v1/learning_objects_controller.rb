class Api::V1::LearningObjectsController < Api::V1::BaseController

  def index
    render json: LearningObject.all, each_serializer: Api::V1::LearningObjectSerializer
  end

end
