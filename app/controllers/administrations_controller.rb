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
    setup = Setup.find(params[:setup_id])
    relations = params[:relations]
    relations.each do |concept, weeks|
      c = Concept.find(concept)
      w = setup.weeks.find(weeks.keys)
      c.weeks = w
    end
    # clear all concepts with nothing checked
    (setup.course.concepts.all - Concept.find(relations.keys)).each do |c|
      c.weeks = []
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

  # Pouziva sa pre vzdialene nacitanie spatnej vazby.
  def question_feedbacks
    @question = LearningObject.find_by_id(params[:id])

    list = @question.feedbacks.includes(:user).order(accepted: :desc).order(created_at: :asc).map do |feedback|
      {
          id: feedback.id,
          accepted: feedback.accepted,
          user_verified: feedback.user.verified?,
          anonymous: feedback.anonymous_teacher,
          message: feedback.message,
          fullname: feedback.user.full_name,
          time: feedback.created_at.strftime("%d.%m.%Y %H:%M:%S"),
          visible: feedback.visible
      }
    end

    render json: list
  end

  # Oznaci spatnu vazbu za schvalenu.
  def mark_feedback_accepted
    Feedback.find(params[:id]).update(accepted: true)
    render js: "Admin.fetchFeedback();"
  end

  # Oznaci spatnu vazbu za zamietnutu.
  def mark_feedback_rejected
    Feedback.find(params[:id]).update(accepted: false)
    render js: "Admin.fetchFeedback();"
  end

  # Zobrazi spatnu vazbu (na stranke s otazkou).
  def mark_feedback_visible
    Feedback.find(params[:id]).update(visible: true)
    render js: "Admin.fetchFeedback();"
  end

  # Skryje spatnu vazbu (na stranke s otazkou).
  def mark_feedback_hidden
    Feedback.find(params[:id]).update(visible: false)
    render js: "Admin.fetchFeedback();"
  end

  # Zmeni nastavenia skrytia mena ucitela v spatnej vazbe.
  def mark_feedback_anonymized
    Feedback.find(params[:id]).update(anonymous_teacher: params[:anonymized] == "true")
    render js: "Admin.fetchFeedback();"
  end

  # Ziska nasledujucu otazku (z kurzu), ku ktorej este nebola pridana spatna vazba.
  def next_feedback_question
    @course = Course.find(params[:id])

    unless session.has_key?(:unresoved_feedbacks) && session[:unresoved_feedbacks].any?
      session[:unresoved_feedbacks] = @course.feedbackable_questions
    end

    lo = LearningObject.where(id: session[:unresoved_feedbacks].pop).first
    if lo
      redirect_to(edit_admin_learning_object_path(lo))
    else
      redirect_to(admin_learning_objects_path(course: @course.id))
    end

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
