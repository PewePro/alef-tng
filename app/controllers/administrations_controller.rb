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
    weeks = @setup.weeks
    week_count = params[:setup][:week_count].to_i
    ActiveRecord::Base.transaction do
      if week_count >= @setup.week_count
        (@setup.week_count+1..week_count).each do |w|
          Week.create!(setup_id: @setup.id, number: w)
        end
      else
          weeks.where(number: week_count+1..@setup.week_count).destroy_all
      end
      @setup.update(params.require(:setup).permit(:week_count, :first_week_at))
    end
    redirect_to setup_config_path, :notice => "Úspešne uložené"
  end

  def setup_config_relations
    render nothing: true
  end

end
