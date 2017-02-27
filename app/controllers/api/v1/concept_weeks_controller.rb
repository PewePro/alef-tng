class Api::V1::ConceptWeeksController < Api::V1::BaseController

  def index
    render json: ConceptsWeek.all, each_serializer: Api::V1::ConceptWeekSerializer
  end

end
