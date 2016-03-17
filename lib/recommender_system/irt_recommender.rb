module RecommenderSystem
  class IrtRecommender < RecommenderSystem::Recommender
    # Metoda vytvori list learning objektov s priradenymi hodnotami na zaklade pravdepodobnosti spravnej odpovede urcenej cez Item Response Theory
    def get_list
      los = self.learning_objects
      list = Hash.new
      user = User.find(self.user_id)
      proficiency = user.proficiency
      los.each do |lo|
        difficulty = lo.irt_difficulty || 0.5
        discrimination = lo.irt_discrimination || 0.5
        # Vypocet pravdepodobnosti na zaklade 2P IRT
        probability = (Math::E**(discrimination*(proficiency-difficulty))) / (1 + Math::E**(discrimination*(proficiency-difficulty)))
        list[lo.id] = probability
      end
      list
    end

    # Opakuje sa o stvrtej rano, vid. config/schedule.rb
    def self.update_table
      # Predspracovanie dat
      result_relations = Levels::Preproces.preproces_data
      number_of_users = User.all.order("id DESC").first.id
      number_of_los = LearningObject.all.order("id DESC").first.id

      # Vytvorenie matice pre vstup
      matrix_relations = Array.new(number_of_users){Array.new(number_of_los){nil} }
      result_relations.each do |rel|
        if rel[1] == 1
          j = rel[0][1]
          i = rel[0][0]
          matrix_relations[i-1][j-1] = 1
        elsif rel[1] == 0
          j = rel[0][1]
          i = rel[0][0]
          matrix_relations[i-1][j-1] = 0
        end
      end

      # Odstranenie userov, ktori nam nic nepovedia - user, ktory ma menej ako 10 odpovedi

      array_of_deleted = matrix_relations.map {|m| m.count(1) + m.count(0) < 2}
      user_deleted = array_of_deleted.each_with_index.map { |a, i| a == true ? i : nil }.compact
      matrix_relations = matrix_relations.reject {|m| m.count(1) + m.count(0) < 2}
      user_deleted = user_deleted.map{ |u| u+1 } # indexuje sa od 0 ale idcka su od 1!
      user_solved = 1..number_of_users
      user_solved = user_solved.reject{ |id| user_deleted.include?(id) }

      # Odstranenie otazok, ktore nam nic nepovedia - otazka, ktora ma menej ako 10 odpovedi

      array_of_deleted = matrix_relations.transpose.map {|m| m.count(1) + m.count(0) < 2}
      items_deleted = array_of_deleted.each_with_index.map { |a, i| a == true ? i : nil }.compact
      matrix_relations = (matrix_relations.transpose.reject {|m| m.count(1) + m.count(0) < 2}).transpose
      items_deleted = items_deleted.map{ |u| u+1 } # indexuje sa od 0 ale idcka su od 1!

     unless matrix_relations.count == 0

        tmp = ""
        user = ""
        input_large = Array.new
        list_of_users = Hash.new
        j=0

        matrix_relations.each do |m|
          m.each do |mi|
            if mi.nil?
              add = "NA,"
            else
              add = mi.to_s + ","
            end
            user = user + add
            if tmp.bytesize  + add.bytesize < 3000
              tmp = tmp + add
            else
              input_large.push(tmp)
              tmp = add
            end
          end
          list_of_users[user_solved[j]] = user
          j += 1
          user = ""
          tmp += "-"

        end
        input_large.push(tmp)


        R.eval "x <- '' "
        input_large.each do |inp|
          R.eval "y <- '#{inp}' "
          R.eval "x <- paste(x, y, sep = "") "
        end

        R.eval <<EOF
          arr <- strsplit(x, ",-")
          result = matrix(nrow=length(arr[[1]]), ncol = #{matrix_relations[0].count})
          library(stringr)
          for(i in 1:length(arr[[1]]))
          {
            temp <- strsplit(arr[[1]][i], ",")
            for (j in 1:length(temp[[1]]))
            {
              number <- temp[[1]][j]
              number <- str_replace_all(number, fixed(" "), "")
              if(number == "1")
              {
                result[i,j]=1
              }
              if(number == "0")
              {
                result[i,j]=0
              }
            }
          }
          #spustenie irt
          library(ltm)
          model = ltm(result ~ z1, IRT.param = TRUE)
          result_items <- coef(model)
          result_users <- factor.scores(model)
          result_users <- toString(result_users)
EOF
          result_items = R.pull "result_items"
          result_users = R.pull "result_users"


       # Ulozenie parametrov otazok, ak su v rozumnom rozsahu, ak je malo dat zbytocne ukladat skreslene data
         unless result_items.nil?
           j=0
           for i in 1..number_of_los
             if (items_deleted.include?(i))
               next
             end
             if (result_items.row(j)[0].to_f > -100 && result_items.row(j)[0] < 100 && result_items.row(j)[1].to_f > -100 && result_items.row(j)[1] < 100)
               LearningObject.find(i).update!(irt_difficulty: result_items.row(j)[0].to_f)
               LearningObject.find(i).update!(irt_discrimination: result_items.row(j)[1].to_f)
             end
             j += 1
           end
         end

       # Spracovanie matice pre userov
         unless result_users.nil?
           i = result_users.index(", z1 = c(")
           j = result_users.index("), se.z1 =")
           z = result_users[i+9..j-1].gsub!(" ","").split(/,/).map{|z1| z1.to_f}
           items = result_users.split("Item")
           items.delete_at(0)
           items_clear = Array.new
           items.each do |it|
             i = it.index(" = c(")
             j = it.index("),")
             values = it[i+5..j-1].gsub!(" ","")
             if values.include?("\n")
               values.delete!("\n")
             end
             items_clear.push(values)
           end

           # Pripravenie userov
           user_final = Array.new
           i = 1
           items_clear.each do |ic|

             ic_split = ic.split(",")
             j = 0
             ic_split.each do |icp|
               if i == 1
                 user_final.push(icp.to_s + ",")
               else
                 user_final[j] = user_final[j] + icp.to_s + ","
                 j += 1
               end
             end
             i += 1
           end

           # Ulozenie proficiency pre userov
           for i in 0..user_final.count-1
             id = list_of_users.key(user_final[i])
             if id.present? && z[i] > -100 && z[i] < 100
                User.find(id).update!(proficiency: z[i].to_f)
             end
           end

         end

        end

    end

  end
end