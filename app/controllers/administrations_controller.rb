class AdministrationsController < ApplicationController

  after_filter :save_my_previous_url

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

  def question_config
    @questions = LearningObject.all
  end

  def edit_question_config
    @question = LearningObject.find_by_id(params[:question_id])
  end

  def save_my_previous_url
    # session[:previous_url] is a Rails built-in variable to save last url.
    session[:my_previous_url] = URI(request.referer).path
  end

  def edit_question
    lo = LearningObject.find_by_id(params[:question_id])
    lo.update(:lo_id => params[:edit_question_name]) if params[:edit_question_name] != ""
    lo.update(:question_text => params[:edit_question_text]) if params[:edit_question_text] != ""
    lo.answers.each do |a|
      is_correct = false
      is_correct = true if params["correct_answer_#{a.id}"]
      a.update(:answer_text => params["edit_answer_text_#{a.id}"], :is_correct => is_correct) if params["edit_answer_text_#{a.id}"] != ""
    end

    redirect_to session.delete(:my_previous_url), :notice => "Otázka bola upravená"
    #redirect_to question_config_path, :notice => "Otázka bola upravená"
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
