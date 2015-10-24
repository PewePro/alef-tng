class RoomsController < ApplicationController
  def show
    @setup = Setup.take
    @week = @setup.weeks.find_by_number(params[:week_number])

    @room = Room.find_by_id(params[:room_number])

    @next_room = @room.next
    @previous_room = @room.previous


    @learning_objects = @room.learning_objects.all.distinct
    @results = UserToLoRelation.get_results(current_user.id,@week.id)

    #RecommenderSystem::Recommender.setup(current_user.id,@week.id)
    #recommendations = RecommenderSystem::HybridRecommender.new.get_list

    #@sorted_los = Array.new
    #recommendations.each do |key, value|
    #  @sorted_los << learning_objects.find {|l| l.id == key}
    #end

    #@activity = Levels::EvaluationActivities.activity(@sorted_los.count,learning_objects, @user, @results)

    @user = current_user
  end


end
