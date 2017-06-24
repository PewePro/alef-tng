class WeeksController < ApplicationController
  def show
    @setup = Setup.take
    @week = @setup.weeks.find_by_number(params[:week_number])

    unless @week.is_visible?
      flash[:notice] = t('global.errors.something_went_wrong')
      return redirect_to(index_week_path)
    end

    @next_week = @week.next
    @previous_week = @week.previous

    learning_objects = @week.learning_objects.all.distinct
    @results = UserToLoRelation.get_results(current_user.id,@week.id)

    @sorted_los = learning_objects

  end

  def list
    @setup = Setup.take
    @weeks = @setup.weeks.order(number: :desc)
  end
end
