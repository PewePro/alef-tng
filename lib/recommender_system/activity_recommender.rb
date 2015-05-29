module RecommenderSystem
  class ActivityRecommender < RecommenderSystem::Recommender

    def get_list

      relations = get_model

      list = Hash.new

      # Pre kazdu otazku z tyzdna vyrata priemernu pravdepodobnost vzhladom na otazky z modelu aktivity
      self.learning_objects.each do |lo|
        list[lo.id] = 0
        relations.each do |r|
          list[lo.id] += get_probability(lo, r)
        end
        list[lo.id] = list[lo.id].to_f / relations.count unless relations.count == 0
      end

      normalize list
    end


    def get_model
      recent_activity = UserToLoRelation.where('user_id = (?) AND created_at > (?)', self.user_id, Date.today - 1.day).order(:created_at).to_a

      return [] if recent_activity.empty? or recent_activity.last.created_at < Date.today - 1.hour

      # Zoberie poslednu aktivitu pouzivatela z dnesneho dna a odstrihne vsetky relacie, ktore od zvysku oddeluje aspon hodinova pauza
      model = Array.new
      begin
        model = [recent_activity.pop] + model
      end while (not recent_activity.empty?) and
                model.first.created_at - 1.hour < recent_activity.last.created_at

      final_model = self.class.remove_redundant_relations model

      final_model.last 20
    end

    def self.remove_redundant_relations model
      # Odstrani nadbytocne relacie Visited
      (1..(model.count - 1)).reverse_each do |i|
        if  model[i-1].type == 'UserVisitedLoRelation' and
            (model[i].type == 'UserSolvedLoRelation' or model[i].type == 'UserFailedLoRelation' or model[i].type == 'UserDidntKnowLoRelation') and
            model[i-1].learning_object_id == model[i].learning_object_id

          model.delete_at (i-1)
        end
      end

      # Odstrani nadbytocne relacie Solved
      (1..(model.count - 1)).reverse_each do |i|
        if  model[i].type == 'UserSolvedLoRelation' and
            (model[i-1].type == 'UserViewedSolutionLoRelation' or model[i-1].type == 'UserFailedLoRelation' or model[i-1].type == 'UserDidntKnowLoRelation') and
            model[i].learning_object_id == model[i-1].learning_object_id

          model.delete_at i
        end
      end

      model
    end


    def get_probability (learning_object, relation)
      # TODO: iba jeden pristup do tejto tabulky, urobit to raz a uz len vytahovat vysledky

      activity = ActivityRecommenderRecord.where(
          learning_object_id: learning_object.id,
          relation_learning_object_id: relation.learning_object_id,
          relation_type: relation.type
      ).take

      activity_rate = get_success_rate activity
      success_rate = get_success_rate learning_object

      activity_rate - success_rate
    end


    # Uprednostnuje este neriesene otazky, aby sa nazbierala aktivita
    def get_success_rate obj
      if obj.nil?
        1
      elsif obj.right_answers == 0
        0
      else
        obj.right_answers.to_f / (obj.right_answers + obj.wrong_answers)
      end
    end


    # Opakuje sa o stvrtej rano, vid. config/schedule.rb
    def self.update_table

      relations = UserToLoRelation.where(activity_recommender_check: false).order(:user_id, :created_at)

      breakpoints = [0]
      relations.each_with_index do |_, index|
        if index > 0
          if relations[index].user_id != relations[index-1].user_id or
              relations[index-1].created_at < relations[index].created_at - 1.hour

            breakpoints << index

          end
        end
      end
      breakpoints << relations.count

      models = Array.new

      (1..(breakpoints.count - 1)).each do |i|
        models << relations[breakpoints[i-1]..(breakpoints[i]-1)]
      end

      models.each do |model|
        process_model model
      end

    end


    def self.process_model model

      final_model = remove_redundant_relations model

      final_model.each_with_index do |rel, index|
        if index > 0

          operation = :none
          if rel.type == 'UserSolvedLoRelation'
            operation = :right
          end
          if rel.type == 'UserFailedLoRelation' or rel.type == 'UserDidntKnowLoRelation'
            operation = :wrong
          end

          unless operation == :none
            final_model[0..(index-1)].each do |rel_before|
              ActivityRecommenderRecord.process_record rel.learning_object_id, operation, rel_before
            end
          end

        end
      end

      UserToLoRelation.where('id IN (?)', model.map(&:id)).update_all(activity_recommender_check: true)

    end


  end
end