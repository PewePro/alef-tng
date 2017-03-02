class Api::V1::ConceptsController < Api::V1::BaseController

  def index
    render json: { list: Concept.all }, each_serializer: Api::V1::ConceptSerializer
  end

end
