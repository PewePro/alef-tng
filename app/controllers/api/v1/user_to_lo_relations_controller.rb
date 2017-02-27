class Api::V1::UserToLoRelationsController < Api::V1::BaseController

  def index
    render json: apply_filter(UserToLoRelation), each_serializer: Api::V1::UserToLoRelationSerializer
  end

end
