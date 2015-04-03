class AdministrationsController < ApplicationController
  authorize_resource :class => false
  def index
  end

  def setup_config
    @setup = Setup.find(params[:setup_id])
    @concepts = @setup.course.concepts.includes(:weeks)
  end

  def setup_config_attributes
    @setup = Setup.find(params[:setup_id])
    @setup.update(params.require(:setup).permit(:week_count, :first_week_at))
    redirect_to setup_config_path, :notice => "Úspešne uložené"
  end

  def setup_config_relations
    render nothing: true
  end

end
