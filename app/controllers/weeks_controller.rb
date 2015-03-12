class WeeksController < ApplicationController
  def show
    @week = Week.find_by_number(params[:number])
    @learning_objects = LearningObject.joins(:user_to_lo_relations).joins(concepts: :weeks).where('weeks.id = 1 AND user_to_lo_relations.user_id = 1')
  end
end
