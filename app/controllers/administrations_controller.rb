class AdministrationsController < ApplicationController
  authorize_resource :class => false
  def index
  end

  def setup_config
    @setup = Setup.find(params[:setup_id])
    @concepts = @setup.course.concepts.includes(:weeks)
  end
end
