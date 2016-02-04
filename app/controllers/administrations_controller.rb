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

    feedback_new_count = Feedback.where(accepted: nil).where.not(learning_object_id: nil).count
    feedback_aggs = feedback_new_count > 0 ? Feedback.select("learning_object_id").where(accepted: nil).group(:learning_object_id).count : {}
    @feedbacks = {
        aggs: feedback_aggs,
        count: feedback_new_count
    }
  end

  def edit_question_config
    @question = LearningObject.find_by_id(params[:question_id])
  end

  def edit_question
    LearningObject.find_by_id(params[:question_id]).update!(
        lo_id: params[:edit_question_name],
        question_text: params[:edit_question_text]
    )

    redirect_to edit_question_config_path, :notice => "Otázka bola úspešne uložená."
  end

  # Ulozi zmeny v odpovediach na otazky.
  def edit_answers
    lo = LearningObject.find_by_id(params[:question_id])

    begin
      ActiveRecord::Base.transaction do
        lo.answers.force_all.each do |a|
          a.update!(
              is_correct: !!params["correct_answer_#{a.id}"],
              visible: !!params["visible_answer_#{a.id}"],
              answer_text: params["edit_answer_text_#{a.id}"]
          )
        end
        lo.validate_answers!
      end
    rescue AnswersCorrectnessError
      return redirect_to(edit_question_config_path, :alert => "Otázka nesmie mať viac ako jednu správnu odpoveď.")
    rescue AnswersVisibilityError
      return redirect_to(edit_question_config_path, :alert => "Otázka nesmie mať viac ako jednu viditeľnú odpoveď.")
    end

    redirect_to edit_question_config_path, :notice => "Zmeny v odpovediach boli úspešne uložené."
  end

  def delete_answer
    answer = Answer.find_by_id(params[:answer_id])
    answer.destroy
    redirect_to edit_question_config_path, :notice => "Odpoveď bola odstránená"
  end

  def add_answer
    lo = LearningObject.find_by_id(params[:question_id])

    begin
      ActiveRecord::Base.transaction do
        correct = !!params[:correct_answer]
        visible = !!params[:visible_answer]
        Answer.create!({
                           answer_text: params[:add_answer_text],
                           learning_object_id: params[:question_id],
                           is_correct: correct,
                           visible: visible
                       })
        lo.validate_answers!
      end
    rescue AnswersCorrectnessError
      return redirect_to(edit_question_config_path, :alert => "Otázka nesmie mať viac ako jednu správnu odpoveď.")
    rescue AnswersVisibilityError
      return redirect_to(edit_question_config_path, :alert => "Otázka nesmie mať viac ako jednu viditeľnú odpoveď.")
    end

    redirect_to edit_question_config_path, :notice => "Odpoveď bola pridaná."
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
          message: feedback.message,
          fullname: "#{feedback.user.first_name} #{feedback.user.last_name}",
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
