class ActivityRecommenderRecord < ActiveRecord::Base

  def self.process_record (lo_id, operation, rel)

    record = self.where(  learning_object_id: lo_id,
                          relation_learning_object_id: rel.learning_object_id,
                          relation_type: rel.type
                        ).take

    if record.nil?
      record = ActivityRecommenderRecord.new(
          learning_object_id: lo_id,
          relation_learning_object_id: rel.learning_object_id,
          relation_type: rel.type
      )
    end

    if operation == :right
      record.update(right_answers: record.right_answers + 1)
    end

    if operation == :wrong
      record.update(wrong_answers: record.wrong_answers + 1)
    end

  end

end