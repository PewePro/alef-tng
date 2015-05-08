module RecommenderSystem
  class ActivityRecommender < RecommenderSystem::Recommender

    def get_list

      relations = self.get_model

      list = Hash.new

      # Pre kazdu otazku z tyzdna vyrata priemernu pravdepodobnost vzhladom na otazky z modelu aktivity
      self.learning_objects.each do |lo|
        list[lo.id] = 0
        relations.each do |r|
          list[lo.id] += self.get_probability(lo, r)
        end
        list[lo.id] = list[lo.id].to_f / self.learning_objects.count
      end

      list
    end


    def get_model
      relations = UserToLoRelation.where('user_id = (?) AND created_at > (?)', self.user_id, Date.today - 1.day)

      # odpal ak je tam niekde hodinova medzera

      # odpal tie nadbytocne

      relations
    end


    def get_probability (learning_object, relation)
      activity_rate = ActivityRecommenderRecord.where(
          learning_object_id: learning_object.id,
          relation_learning_object_id: relation.learning_object_id,
          relation_type: relation.type
      ).select('right_answers / (right_answers + wrong_answers)')

      success_rate = learning_object.right_answers.to_f / (learning_object.right_answers + learning_object.wrong_answers)

      activity_rate - success_rate
    end


    def update_table
      # toto rob kazdu hodinu

      # zober vsetky relacie, ktore este neboli spracovane
      # vytvor z nich modely
      # z modelov obnov tabulku
    end

    # pridat relaciam stlpec, ktory hovori, ci uz boli spracovane pre tieto potreby


  end
end