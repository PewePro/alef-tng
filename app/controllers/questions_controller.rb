class QuestionsController < ApplicationController
  def show
    @question = LearningObject.find(params[:id])
    @question.seen_by_user(1)
    @next_question = @question.next(params[:number])
    @previous_question = @question.previous(params[:number])

    @answers = @question.answers
    @relations = UserToLoRelation.where(learning_object_id: params[:id], user_id: 1).group('type').count

    puts @relations
    puts @relations["UserVisitedLoRelation"]

  end
end
