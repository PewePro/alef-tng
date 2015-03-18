class WeeksController < ApplicationController
  def show
    @setup = Setup.take
    @week = @setup.weeks.find_by_number(params[:number])
    @next_week = @week.next
    @previous_week = @week.previous

    @learning_objects = @week.learning_objects.distinct

    @relations = UserToLoRelation.
            where('learning_object_id IN (?)', @learning_objects.map(&:id)).
            where('user_id = ?', 1).
            group(:learning_object_id, :type).count

    @lo_number_all = @learning_objects.count
    @lo_number_done = @relations.select {|k,v| k[1] == "UserCompletedLoRelation"}.size
  end

  def list
    # zoznam tyzdnov
  end

end
