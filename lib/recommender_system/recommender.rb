module RecommenderSystem
  class Recommender

    def self.setup(user_id, week_id)
      @@user_id = user_id
      @@week_id = week_id
      @@los = Hash.new
      @@rels = Hash.new
    end

    def self.learning_objects
      if @@los.empty?
        @@los = Week.find(@@week_id).learning_objects.includes(:concepts).uniq
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
        )
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

    def get_best
      self.get_list.first
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