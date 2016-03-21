class RoomsController < ApplicationController
  before_action :check_path

  def show
    setup = Setup.take
    week = setup.weeks.find_by_number(params[:week_number])

    @room = Room.find_by_id(params[:room_number])

    @next_room = @room.next(current_user.id,week.id)
    @previous_room = @room.previous(current_user.id,week.id)

    @learning_objects = @room.learning_objects.order(id: :asc)
    @results = UserToLoRelation.get_results(current_user.id,week.id)
  end

  def eval
    @room = Room.find(params[:room_number])
    learning_objects = @room.learning_objects

    @score_limit = @room.score_limit
    week = Week.find_by_id(@room.week_id)

    @count_real = (week.learning_objects.distinct.count / Room::NUMBER_LOS_IN_ROOM).to_i
    unless (week.learning_objects.distinct.count % Room::NUMBER_LOS_IN_ROOM == 0)
      @count_real +=1
    end

    @count_actual = week.rooms.where("user_id = ? AND state = ?", current_user.id, "used").count

    if @room.state == "used"
      @room_for_open = week.rooms.where("state = ?","do_not_use").first
      @score = @room.score
    else
      @count_actual += 1

      # Ziskanie skore za komentare a vypocitanie noveho celkoveho skore
      @score = @room.score + Levels::ScoreCalculation.compute_score_for_comments(learning_objects,current_user)

      if (@count_real <= @count_actual && @score >= @score_limit)
        # Ak som na poslednej miestnosti v tyzdni a dosiahla som potrebne skore, nastavim stav na pouzita
        @room.update!(state: "used")
      end

      if (@score >= @score_limit)
        # Ak som dosiahla potrebne skore v miestnosti, toto skore sa ulozi
        @room.update!(score: @score)
      else
        # Ak som nedosiahla potrebne skore, znovu sa prepocita hranicne skore a moje skore sa vynuluje
        val = Levels::ScoreCalculation.compute_limit_score(learning_objects)
        @room.update!(score_limit: val.to_f)
        @room.update!(score: 0.0)
      end
    end

    @room.update!(number_of_try: (@room.number_of_try + 1))

    @next_room = nil
    @previous_room = nil
  end

  def new
    setup = Setup.take
    week = setup.weeks.find_by_number(params[:week_number])
    room = Room.find(params[:room_number])
    if room.state == "used"
      redirect_to controller: "weeks", action: "show"
    else
      room.update!(state: "used")
      room_id = Levels::RoomsCreation.create(week.id, current_user.id)
      redirect_to action: "show", room_number: room_id
    end
  end

  def check_path
    if current_user.andand.has_rooms?
      room = current_user.rooms.where("id = ?", params[:room_number])
      # Ak danu miestnost nema spristupnenu, zobrazi sa mu prva z daneho tyzdna, ktoru ma k dispozicii
      if room.count == 0
        available_room = current_user.rooms.where("week_id = ?", params[:week_number]).first
        redirect_to :controller => 'rooms', :action => 'show', :room_number => available_room.id
      end
    else
      redirect_to :controller => 'weeks', :action => 'show'
    end
  end

end
