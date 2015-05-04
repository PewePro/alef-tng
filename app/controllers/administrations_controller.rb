class AdministrationsController < ApplicationController
  authorize_resource :class => false
  def index
    @setups = Setup.all
    @courses = Course.all
  end

  def setup_config
    @setup = Setup.find(params[:setup_id])
    @concepts = @setup.course.concepts.includes(:weeks).order(:pseudo, :name)
    @weeks = @setup.weeks.order(:number)
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
      @setup.update(params.require(:setup).permit(:week_count, :first_week_at, :show_all))
    end
    redirect_to setup_config_path, :notice => "Úspešne uložené"
  end

  def setup_config_relations
    relations = params[:relations]
    relations.each do |concept, weeks|
      c = Concept.find(concept)
      w = Setup.find(params[:setup_id]).weeks.find(weeks.keys)
      c.weeks = w
    end
    redirect_to setup_config_path, :notice => "Úspešne uložené"
  end


  def download_statistics
    @setup = Setup.find(params[:_setup_id])
    filepath_full = @setup.compute_stats()
    send_file filepath_full
  end

  def question_concept_config
    @course = Course.find(params[:course_id])
    @questions = @course.learning_objects.includes(:answers,:concepts).all
    gon.concepts = @course.concepts.pluck(:name)
  end

  def delete_question_concept
    question = LearningObject.find(params[:question_id])
    Concept.find(params[:concept_id]).learning_objects.delete(question)
  end

  def add_question_concept
    if params[:concept_name].empty?
      render nothing: true
      return
    end

    @concept = Course.find(params[:course_id]).concepts.find_by_name(params[:concept_name])
    @question = LearningObject.find(params[:question_id])

    if (not(@concept.nil?)) && (not(@question.concepts.include? @concept))
      @question.concepts << @concept
      return
    end
    render nothing: true
  end

end
