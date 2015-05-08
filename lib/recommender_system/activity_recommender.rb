module RecommenderSystem
  class ActivityRecommender < RecommenderSystem::Recommender

    def get_list

      relations = self.get_model

      list = Hash.new

      self.learning_objects.each do |lo|
        list[lo.id] = 0
        relations.each do |r|
          list[lo.id] += self.get_probablity(lo, r)
        end
        list[lo.id] = list[lo.id].to_f / self.learning_objects.count
      end

      list
    end

    def get_model
      # zober vsetky aktivity za poslednych 24h
      # odpal ak je tam niekde hodinova medzera
      # odpal tie nadbytocne
      # vrat zoznam
    end

    def get_probability (learning_object, relation)
      activity_rate = ActivityRecommenderRecord.where(
          learning_object_id: learning_object.id,
          relation_learning_object_id: relation.learning_object_id,
          relation_type: relation.type
      ).select('positive / (positive + negative)')

      success_rate = learning_object.right_answers.to_f / (learning_object.right_answers + learning_object.wrong_answers)

      activity_rate - success_rate
    end

    def update_table
      # zober vsetky relacie, ktore este neboli spracovane
      # vytvor z nich modely
      # z modelov obnov tabulku
    end

    # tabulka
    # lo_id
    # akt_lo_id
    # akt_lo_type
    # right
    # wrong

    # vytvorit tabulku uspesnosti, pouzivat aj pri dalsom recommenderi
    # tam dat right a wrong

    # tieto tabulky updatovat pri kazdej novej relation alebo hromadne?
    # treba vytvorit aj skript pre vytvorenie tychto tabuliek nanovo?


  end
end