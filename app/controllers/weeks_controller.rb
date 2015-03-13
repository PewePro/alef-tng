class WeeksController < ApplicationController
  def show
    @week = Week.find_by_number(params[:number])
    @learning_objects = LearningObject.joins(concepts: :weeks).where('weeks.id = ?',params[:number]).distinct

    # tri atributy: id learning objectu, typ vztahu a pocet takychto vztahov medzi LO a prihlasenym pouzivatelom
    @relations = UserToLoRelation.find_by_sql('SELECT COUNT(*) AS count, lo_final.id AS learning_object_id, utlr.type FROM

      (SELECT lo.id FROM learning_objects AS lo
      JOIN concepts_learning_objects AS loc ON loc.learning_object_id = lo.id
      JOIN concepts AS c ON c.id = loc.concept_id
      JOIN concepts_weeks AS cw ON cw.concept_id = c.id
      WHERE cw.week_id = 1
      GROUP BY lo.id) AS lo_final

    JOIN user_to_lo_relations AS utlr ON utlr.learning_object_id = lo_final.id
    WHERE utlr.user_id = 1
    GROUP BY utlr.type, lo_final.id')

  end

  private
  ## Strong Parameters
  def user_to_lo_relation_params
    params.require(:user_to_lo_relation).permit(:count)
  end

  def learning_object_params
    params.require(:learning_object).permit(:seen, :done)
  end

end
