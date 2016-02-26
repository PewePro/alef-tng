class WeeksController < ApplicationController
  def show
    @setup = Setup.take
    @week = @setup.weeks.find_by_number(params[:week_number])
    @next_week = @week.next
    @previous_week = @week.previous

    if (@week.rooms.where(user_id: current_user.id ).count == 0)
      Levels::RoomsCreation.create(@week.id, current_user.id)
    end
    @rooms = @week.rooms.where("user_id = ?", current_user.id).order(state: :asc, id: :asc)
  end

  def list
    @setup = Setup.take
    @weeks = @setup.weeks.order(number: :desc)
  end
end
