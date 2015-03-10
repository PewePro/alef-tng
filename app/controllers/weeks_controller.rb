class WeeksController < ApplicationController
  def show
    @week = Week.find_by_number(params[:number])
    @learning_objects = @week.learning_objects
  end
end
