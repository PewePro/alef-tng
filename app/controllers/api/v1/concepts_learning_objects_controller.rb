class Api::V1::ConceptsLearningObjectsController < Api::V1::BaseController

  def index
    render json: { list: ConceptsLearningObject.all }, each_serializer: Api::V1::ConceptsLearningObjectSerializer
  end

end
