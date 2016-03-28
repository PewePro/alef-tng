class WeeksController < ApplicationController
  def show
    @setup = Setup.take
    @week = @setup.weeks.find_by_number(params[:week_number])
    @next_week = @week.next
    @previous_week = @week.previous

    if current_user.has_rooms?
      if (@week.rooms.where(user_id: current_user.id ).count == 0)
        Levels::RoomsCreation.create(@week.id, current_user.id)
      end
      @rooms = @week.rooms.where("user_id = ?", current_user.id).order(state: :asc, id: :asc)
    else
      learning_objects = @week.learning_objects.all.distinct
      @results = UserToLoRelation.get_results(current_user.id,@week.id)

      RecommenderSystem::Recommender.setup(current_user.id,@week.id,nil)
      recommendations = RecommenderSystem::HybridRecommender.new.get_list

      @sorted_los = Array.new
      recommendations.each do |key, value|
        @sorted_los << learning_objects.find {|l| l.id == key}
      end
    end

  end

  def list
    @setup = Setup.take
    @weeks = @setup.weeks.order(number: :desc)
  end
end
