class Api::V1::CoursesController < Api::V1::BaseController

  def index
    render json: { list: Course.all }, each_serializer: Api::V1::CourseSerializer
  end

end
