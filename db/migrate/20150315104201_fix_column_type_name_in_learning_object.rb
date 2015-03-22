class FixColumnTypeNameInLearningObject < ActiveRecord::Migration
  def self.up 
    change_table(:learning_objects) do |t|
      t.rename :type, :question_type
    end
  end
  def self.down
    change_table(:learning_objects) do |t|
      t.rename :question_type, :type
    end
  end
end
