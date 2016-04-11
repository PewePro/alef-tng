class WeeksController < ApplicationController
  def show
    @setup = Setup.take
    @week = @setup.weeks.find_by_number(params[:week_number])
    @next_week = @week.next
    @previous_week = @week.previous

    if current_user.has_rooms?
      if @week.learning_objects.count > 0
        if (@week.rooms.where(user_id: current_user.id ).count == 0)
          Levels::RoomsCreation.create(@week.id, current_user.id)
        end
        @rooms = @week.rooms.where("user_id = ?", current_user.id).order(state: :asc, id: :asc)
        # Ak boli pridane otazky po vyrieseni vsetkych miestnosti otvori sa jedna miestnost pre vytvorenie novej miestnosti
        if (@rooms[0].state == "used" && @week.free_los(nil,current_user.id).count > 0)
          @rooms[0].update!(state: "do_not_use")
        end
        # Ak sa nachadza viacero miestnosti na otvorenie necha len jednu alebo ziadnu ak uz nema nove learning objecty - boli odobrate
        rooms_open = @rooms.select{|r| r.state == "do_not_use"}
        if rooms_open.count > 1
          unless @week.free_los(nil,current_user.id).count == 0 # Ak su este nejake volne otazky, necha jednu miestnost na ich otvorenie
            rooms_open.shift
          end
          rooms_open.each do |r|
            r.update(state: "used")
          end
        end
        # Odstranenie miestnosti, ktore boli vytvorene bez learning objectov
        rooms_deleted = @rooms.select{|r| r.learning_objects.count == 0}
        if rooms_deleted.count > 0
          rooms_deleted.each do |r|
            r.destroy
          end
          @rooms = @week.rooms.where("user_id = ?", current_user.id).order(state: :asc, id: :asc)
        end
      end
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
