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

  def question_config
    @questions = LearningObject.all
  end

  def edit_question_config
    @question = LearningObject.find_by_id(params[:question_id])
  end

  def edit_question
    puts "QUESTION_NAME: #{params[:edit_question_name]} ; QUESTION_TEXT: #{params[:edit_question_text]}"
    LearningObject.find_by_id(params[:question_id]).update(:lo_id => params[:edit_question_name]) if params[:edit_question_name] != ""
    LearningObject.find_by_id(params[:question_id]).update(:question_text => params[:edit_question_text]) if params[:edit_question_text] != ""
    LearningObject.find_by_id(params[:question_id]).answers.each do |a|
      puts "ANSWER ID #{a.id}: #{params["edit_answer_text_#{a.id}"]}" if params["edit_answer_text_#{a.id}"] != ""
      a.update(:answer_text => params["edit_answer_text_#{a.id}"]) if params["edit_answer_text_#{a.id}"] != ""
    end

    redirect_to question_config_path, :notice => "Otázka bola upravená"
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
