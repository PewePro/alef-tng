module Levels
  # Triea zabezpecuje predstpracovanie dat pre irt a vypocet obtiaznosti otazok
  class Preproces
    # Metoda na zaklade heuristik vytvori dvojice user - learning object, s hodnotami vie alebo nevie, resp. 1 alebo 0
    def self.preproces_data
      setup = Setup.take
      result_int = Hash.new
      relations = setup.user_to_lo_relations.select("user_id,learning_object_id,
sum(case  when type = 'UserFailedLoRelation' or type = 'UserDidntKnownLoRelation'  then 1 else 0 end) as sum_failed,
sum(case  when type = 'UserSolvedLoRelation' then 1 else 0 end) as sum_solved, (array_agg(type ORDER BY created_at))[1:3] grouped_type ")
                      .where("type = ? OR type = ? OR type = ?",'UserFailedLoRelation', 'UserDidntKnownLoRelation','UserSolvedLoRelation')
                      .group(:user_id, :learning_object_id)

      # Vyhodnotenie na zaklade heuristik ci student danu otazku vie, alebo nevie
      relations.each do |r|
        tree_last_rel = r.grouped_type
        if tree_last_rel.count == 3 && tree_last_rel.count("UserSolvedLoRelation") == 3
          result_int[[r.user_id,r.learning_object_id]] = 1
        elsif tree_last_rel.count >=2 && tree_last_rel.first(2).count("UserSolvedLoRelation") == 2 && r.sum_solved >= (r.sum_failed - 1)
          result_int[[r.user_id,r.learning_object_id]] = 1
        elsif tree_last_rel.first =="UserSolvedLoRelation" && (r.sum_solved > r.sum_failed)
          result_int[[r.user_id,r.learning_object_id]] = 1
        elsif tree_last_rel.first =="UserFailedLoRelation" && (r.sum_solved >= (r.sum_failed + 2))
          result_int[[r.user_id,r.learning_object_id]] = 1
        else
          result_int[[r.user_id,r.learning_object_id]] = 0
        end

      end

      result_int

    end

    def self.preproces_data_for_lo(learning_object)
      result_int = Array.new
      relations = UserToLoRelation.select("user_id,
sum(case  when type = 'UserFailedLoRelation' or type = 'UserDidntKnownLoRelation'  then 1 else 0 end) as sum_failed,
sum(case  when type = 'UserSolvedLoRelation' then 1 else 0 end) as sum_solved, (array_agg(type ORDER BY created_at))[1:3] grouped_type ")
                      .where("(type = ? OR type = ? OR type = ?) AND learning_object_id = ?",'UserFailedLoRelation', 'UserDidntKnownLoRelation','UserSolvedLoRelation',learning_object.id)
                      .group(:user_id)

      # Vyhodnotenie na zaklade heuristik ci student danu otazku vie, alebo nevie
      relations.each do |r|
        tree_last_rel = r.grouped_type
        if tree_last_rel.count == 3 && tree_last_rel.count("UserSolvedLoRelation") == 3
          result_int.push(1)
        elsif tree_last_rel.count >=2 && tree_last_rel.first(2).count("UserSolvedLoRelation") == 2 && r.sum_solved >= (r.sum_failed - 1)
          result_int.push(1)
        elsif tree_last_rel.first =="UserSolvedLoRelation" && (r.sum_solved > r.sum_failed)
          result_int.push(1)
        elsif tree_last_rel.first =="UserFailedLoRelation" && (r.sum_solved >= (r.sum_failed + 2))
          result_int.push(1)
        else
          result_int.push(0)
        end
      end

      result_int
    end

  end
end