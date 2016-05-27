class DisableInvolvedInGamificationForUsers < ActiveRecord::Migration
  def up
    add_column :users, :was_involved_in_gamification, :boolean, default: false
    User.all.each do |u|
      u.was_involved_in_gamification = u.involved_in_gamification
      u.involved_in_gamification = false
      u.save!
    end
  end

  def down
    User.all.each do |u|
      u.involved_in_gamification = u.was_involved_in_gamification
      u.save!
    end
    remove_column :users, :was_involved_in_gamification
  end
end
