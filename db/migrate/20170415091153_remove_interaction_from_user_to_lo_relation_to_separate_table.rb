class RemoveInteractionFromUserToLoRelationToSeparateTable < ActiveRecord::Migration
  def up
    create_table :user_solution_lo_relations do |t|
      t.integer :answer_id
      t.integer :user_to_lo_relation_id
      t.float :user_answer_evaluator
    end
    add_foreign_key :user_solution_lo_relations, :answers
    add_foreign_key :user_solution_lo_relations, :user_to_lo_relations

    UserFailedLoRelation.all.each do |rel|
      if rel.interaction.present?
        if rel.learning_object.type == "SingleChoiceQuestion"
          UserSolutionLoRelation.create(:answer_id => rel.interaction.to_i,:user_to_lo_relation_id => rel.id)
        elsif rel.learning_object.type == "MultiChoiceQuestion"
          interactions = eval(rel.interaction).keys
          interactions.each do |int|
            UserSolutionLoRelation.create(:answer_id => int.to_i,:user_to_lo_relation_id => rel.id)
          end
        end
      end
    end

    UserSolvedLoRelation.all.each do |rel|
      if rel.interaction.present?
        if rel.interaction.present?
          if rel.learning_object.type == "SingleChoiceQuestion"
            UserSolutionLoRelation.create(:answer_id => rel.interaction.to_i,:user_to_lo_relation_id => rel.id)
          elsif rel.learning_object.type == "MultiChoiceQuestion"
            interactions = eval(rel.interaction).keys
            interactions.each do |int|
              UserSolutionLoRelation.create(:answer_id => int.to_i,:user_to_lo_relation_id => rel.id)
            end
          elsif rel.learning_object.type == "EvaluatorQuestion"
            answer_id = Answer.find_by_learning_object_id(rel.learning_object_id).id
            UserSolutionLoRelation.create(:answer_id => answer_id,:user_to_lo_relation_id => rel.id,
                                          :user_answer_evaluator => rel.interaction.to_f)
          end
        end
      end
    end
  end

  def down
    drop_table :user_solution_lo_relations
  end
end
