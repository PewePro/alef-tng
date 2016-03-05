class UpdateFirstWeekAtInSetup < ActiveRecord::Migration
  def change

    change_column :setups, :first_week_at, :datetime, null: false

  end
end
