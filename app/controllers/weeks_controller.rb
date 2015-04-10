class WeeksController < ApplicationController
  def show
    @setup = Setup.take
    @week = @setup.weeks.find_by_number(params[:week_number])
    @next_week = @week.next
    @previous_week = @week.previous

    @learning_objects = @week.learning_objects.distinct

    @user = current_user
    @relations = UserToLoRelation.get_basic_relations(@learning_objects, @user.id)

    @lo_number_all = @learning_objects.count
    @lo_number_done = @relations.select {|k,_| k[1] == "UserSolvedLoRelation"}.size
  end

  def list
    @setup = Setup.take
    @weeks = @setup.weeks
    @user = current_user
  end
end
