class ChangeValueOfInvolvedInGamification < ActiveRecord::Migration
  def change
    User.update_all(involved_in_gamification: false)
  end
end
