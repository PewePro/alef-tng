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
    @course = Course.find(params[:course_id])
    @questions = @course.learning_objects.eager_load(:answers)
  end

  def edit_question_config
    @question = LearningObject.find_by_id(params[:question_id])
    @feedbacks = {
        not_reviewed: @question.feedbacks.not_reviewed.includes(:user),
        all: @question.feedbacks.includes(:user)
    }
  end

  def edit_question
    #lo.update(:lo_id => params[:edit_question_name]) if params[:edit_question_name] != ""
    #lo.update(:question_text => params[:edit_question_text]) if params[:edit_question_text] != ""
    LearningObject.find_by_id(params[:question_id]).update!(
        lo_id: params[:edit_question_name],
        question_text: params[:edit_question_text])

    redirect_to edit_question_config_path, :notice => "Otázka bola upravená"
  end

  # Ulozi zmeny v odpovediach na otazky.
  def edit_answers
    lo = LearningObject.find_by_id(params[:question_id])
    lo.answers.each do |a|
      a.update!(
          is_correct: params["correct_answer_#{a.id}"],
          answer_text: params["edit_answer_text_#{a.id}"]
      )
    end

    redirect_to edit_question_config_path, :notice => "Otázka bola upravená"
  end

  def delete_answer
    answer = Answer.find_by_id(params[:answer_id])
    answer.destroy
    redirect_to edit_question_config_path, :notice => "Odpoveď bola odstránená"
  end

  def add_answer
    correct_ans = false
    correct_ans = true if params[:correct_answer]
    puts "ANSWER_TEXT: #{params[:add_answer_text]} | LEARNING_OBJECT_ID: #{params[:question_id]} | IS_CORRECT: #{correct_ans}"
    Answer.create!(answer_text: params[:add_answer_text], learning_object_id: params[:question_id], is_correct: correct_ans)
    redirect_to edit_question_config_path, :notice => "Odpoveď bola pridaná"
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

  # Pouziva sa pre vzdialene nacitanie nevyriesenej spatnej vazby (pre widget).
  def question_feedbacks
    @question = LearningObject.find_by_id(params[:id])

    list = @question.feedbacks.not_reviewed.includes(:user).map do |feedback|
      {
          id: feedback.id,
          message: feedback.message,
          fullname: "#{feedback.user.first_name} #{feedback.user.last_name}",
          time: feedback.created_at.strftime("%d.%m.%Y %H:%M:%S")
      }
    end

    render json: list
  end

  # Oznaci spatnu vazbu za schvalenu.
  def mark_feedback_accepted
    Feedback.find(params[:id]).update(accepted: true)
    render js: "Admin.hideFeedbackBox(#{params[:id]});"
  end

  # Oznaci spatnu vazbu za zamietnutu.
  def mark_feedback_rejected
    Feedback.find(params[:id]).update(accepted: false)
    render js: "Admin.hideFeedbackBox(#{params[:id]});"
  end

  # Zobrazi spatnu vazbu (na stranke s otazkou).
  def mark_feedback_visible
    Feedback.find(params[:id]).update(visible: true)
    render nothing: true
  end

  # Skryje spatnu vazbu (na stranke s otazkou).
  def mark_feedback_hidden
    Feedback.find(params[:id]).update(visible: false)
    render js: "Admin.hideFeedbackBox(#{params[:id]});"
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
