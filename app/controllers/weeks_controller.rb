class WeeksController < ApplicationController
  def show
    @setup = Setup.take
    @week = @setup.weeks.find_by_number(params[:week_number])
    @next_week = @week.next
    @previous_week = @week.previous

    RecommenderSystem::Recommender.setup(current_user.id,@week.id)
    recommendations = RecommenderSystem::HybridRecommender.new.get_list

    learning_objects = @week.learning_objects.includes(:user_to_lo_relations).distinct
    @sorted_los = Array.new

    recommendations.each do |key, value|
      @sorted_los << learning_objects.find {|l| l.id == key}
    end

    @user = current_user
  end

  def list
    @setup = Setup.take
    @weeks = @setup.weeks.order(number: :desc)
    @user = current_user
  end
end
