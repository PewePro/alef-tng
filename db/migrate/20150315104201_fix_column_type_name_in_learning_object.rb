class FixColumnTypeNameInLearningObject < ActiveRecord::Migration
  def self.up 
    change_table(:learning_objects) do |t|
      t.rename :type, :question_type
    end
  end
end
