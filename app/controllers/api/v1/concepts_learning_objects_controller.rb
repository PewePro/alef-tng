class Api::V1::ConceptsLearningObjectsController < Api::V1::BaseController

  def index
    render json: ConceptsLearningObject.all, each_serializer: Api::V1::ConceptsLearningObjectSerializer
  end

end
