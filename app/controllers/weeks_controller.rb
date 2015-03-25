class WeeksController < ApplicationController
  def show
    @setup = Setup.take
    @week = @setup.weeks.find_by_number(params[:week_number])
    @next_week = @week.next
    @previous_week = @week.previous

    @learning_objects = @week.learning_objects.distinct

    @relations = UserToLoRelation.get_basic_relations(@learning_objects, 1) # 1 = user_id

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
      week_lo_ids.push(ids.uniq)
    end

    learning_objects = Setup.take.learning_objects.distinct
    relations = UserToLoRelation.get_basic_relations(learning_objects, 1)

    @weeks_info = Array.new
    # najdi pocet learning objectov pre week
    # najdi pocet hotovych
  end
end
