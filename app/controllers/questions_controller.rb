class QuestionsController < ApplicationController
  def show
    @question = LearningObject.find(params[:id])
    @answers = Answer.where(learning_object_id: params[:id])
  end
end
