class ChangeDefaultValueOfInvolvedInGamification < ActiveRecord::Migration
  def up
    change_column_default :users, :involved_in_gamification, false
  end

  def down
    change_column_default :users, :involved_in_gamification, true
  end
end
