class Api::V1::CoursesController < Api::V1::BaseController

  def index
    render json: Course.all, each_serializer: Api::V1::CourseSerializer
  end

end
