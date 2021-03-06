class UserToLoRelation < ActiveRecord::Base
  belongs_to :learning_object
  belongs_to :setup
  belongs_to :user
  belongs_to :room

  def self.get_basic_relations(los, user_id)
    self.
        where("learning_object_id IN (?)", los.map(&:id)).
        where("user_id = ?", user_id).
        where("type = 'UserVisitedLoRelation' OR type = 'UserSolvedLoRelation'").
        group(:learning_object_id, :type).count
  end

  def self.get_results(user_id,week_id)
    sql = '
      SELECT los.id as result_id,
        sum(case when rels.type = \'UserVisitedLoRelation\' then 1 else 0 end) as visited,
      sum(case when rels.type = \'UserSolvedLoRelation\' then 1 else 0 end) as solved
      FROM
      (
        SELECT learning_objects.*
        FROM "learning_objects"
        INNER JOIN "concepts_learning_objects" ON "learning_objects"."id" = "concepts_learning_objects"."learning_object_id"
        INNER JOIN "concepts" ON "concepts_learning_objects"."concept_id" = "concepts"."id"
        INNER JOIN "concepts_weeks" ON "concepts"."id" = "concepts_weeks"."concept_id"
        WHERE "concepts_weeks"."week_id" = '+week_id.to_s+'
        GROUP BY learning_objects.id
      ) AS los
      LEFT JOIN user_to_lo_relations as rels ON rels.learning_object_id = los.id
      WHERE user_id = '+user_id.to_s+'
      GROUP BY los.id
    '
    ActiveRecord::Base.connection.execute(sql)
  end

  def self.get_results_room(user_id,week_id,room_id,number_of_try,lo_id)
    sql = '
      SELECT los.id as result_id,
        sum(case when rels.type = \'UserVisitedLoRelation\' then 1 else 0 end) as visited,
      sum(case when rels.type = \'UserSolvedLoRelation\' then 1 else 0 end) as solved,
      sum(case when rels.type = \'UserDidntKnowLoRelation\' then 1 else 0 end) as donotnow,
      sum(case when rels.type = \'UserFailedLoRelation\' then 1 else 0 end) as failed
      FROM
      (
        SELECT learning_objects.*
        FROM "learning_objects"
        INNER JOIN "concepts_learning_objects" ON "learning_objects"."id" = "concepts_learning_objects"."learning_object_id"
        INNER JOIN "concepts" ON "concepts_learning_objects"."concept_id" = "concepts"."id"
        INNER JOIN "concepts_weeks" ON "concepts"."id" = "concepts_weeks"."concept_id"
        INNER JOIN "weeks" ON "concepts_weeks"."week_id" = "weeks"."id"
        INNER JOIN "rooms" ON "rooms"."week_id" = "weeks"."id"
        WHERE "concepts_weeks"."week_id" = '+week_id.to_s+' AND "learning_objects"."id" = '+lo_id.to_s+'
        GROUP BY learning_objects.id
      ) AS los
      LEFT JOIN user_to_lo_relations as rels ON rels.learning_object_id = los.id
      WHERE user_id = '+user_id.to_s+' AND number_of_try = '+number_of_try.to_s+' AND room_id = '+room_id.to_s+'
      GROUP BY los.id
    '
    ActiveRecord::Base.connection.execute(sql)
  end

end