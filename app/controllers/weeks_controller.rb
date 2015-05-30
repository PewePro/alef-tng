class WeeksController < ApplicationController
  def show
    @setup = Setup.take
    @week = @setup.weeks.find_by_number(params[:week_number])
    @next_week = @week.next
    @previous_week = @week.previous

    RecommenderSystem::Recommender.setup(current_user.id,@week.id)
    recommendations = RecommenderSystem::HybridRecommender.new.get_list
    learning_objects = @week.learning_objects.distinct
    @sorted_los = Array.new

    recommendations.each do |key, value|
      @sorted_los << learning_objects.select {|l| l.id == key}[0]
    end

    @user = current_user
  end

  def list
    @setup = Setup.take
    @weeks = @setup.weeks.order(number: :desc)
    @user = current_user
  end
end
