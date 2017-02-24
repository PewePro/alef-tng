class Api::V1::UserToLoRelationsController < Api::V1::BaseController

  def index
    render json: UserToLoRelation.first(20), each_serializer: Api::V1::UserToLoRelationSerializer
  end

end
