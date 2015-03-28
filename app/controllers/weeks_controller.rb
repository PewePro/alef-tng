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

    week_lo_ids = Array.new
    @weeks.each do |x|
      ids = Rails.cache.fetch('setup_' + x.id.to_s, {expires_in: 1.day}) do
        x.learning_objects.pluck(:id)
      end
      week_lo_ids[x.id] = ids.uniq
    end

    learning_objects = Setup.take.learning_objects.distinct
    relations = UserToLoRelation.get_basic_relations(learning_objects, 1)

    @weeks_info = Array.new
    @weeks.each do |w|
      count = week_lo_ids[w.id].count
      done = week_lo_ids[w.id].select do |x|
          relations[[x,"UserSolvedLoRelation"]] != nil
        end.count
      @weeks_info[w.id] = {count: count, done: done}
    end
  end
end
