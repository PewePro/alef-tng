module RecommenderSystem
  class Recommender

    def self.setup(user_id, week_id, type_question)
      @@user_id = user_id
      @@week_id = week_id
      @@type_question = type_question
      @@los = Hash.new
      @@rels = Hash.new
    end

    # Metoda ziska learning objecty z daneho tyzdna, ktore este nie su zaradene do miestnosti
    def self.learning_objects
      if @@los.empty?
        if User.find(@@user_id).has_rooms?
          @@los = Week.find(@@week_id).free_los(@@type_question,@@user_id)
        else
          @@los = Week.find(@@week_id).learning_objects.includes(:concepts).distinct
        end
      end
      @@los
    end

    def learning_objects
      self.class.learning_objects
    end

    def self.relations
      if @@rels.empty?
        @@rels = UserToLoRelation.where('user_id = (?) AND learning_object_id IN (?)',
                                       @@user_id,
                                       self.learning_objects.map(&:id)
        ).order(:created_at)
      end
      @@rels
    end

    def relations
      self.class.relations
    end

    def user_id
      @@user_id
    end

    def week_id
      @@week_id
    end

    def get_list
        los = self.learning_objects
        list = Hash.new
        los.each do |lo|
          list[lo.id] = 0
        end

        list
    end

    def get_best(last_id)
      list =  self.get_list
      if last_id.present?
        # Osetrenie aby za sebou nenasledovali otazky rovnakeho typu
        type_last = LearningObject.find(last_id).type
        los = LearningObject.where("id IN (?)",list.transpose[0])
        list_hash = list.to_h
        list_hash.each do |l|
          lo = los[los.map{ |lo| lo.id == l[0]}.index(true)]
          unless lo.type == type_last
            return l
          end
        end
      end
      list.first
    end

    def normalize list

      max = list.values.max

      unless max == 0
        list.each do |key,val|
          list[key] = val.to_f / max
        end
      end

      list

    end

  end
end