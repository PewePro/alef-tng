class Api::V1::ConceptWeeksController < Api::V1::BaseController

  def index
    render json: { list: ConceptsWeek.all }, each_serializer: Api::V1::ConceptWeekSerializer
  end

end
