module Levels
  # Triea zabezpecuje predstpracovanie dat pre irt a vypocet obtiaznosti otazok
  class Preproces
    # Metoda na zaklade heuristik vytvori dvojice user - learning object, s hodnotami vie alebo nevie, resp. 1 alebo 0
    def self.preproces_data
      setup = Setup.take
      result = Hash.new
      result_int = Hash.new
      relations = setup.user_to_lo_relations
      relations. each do |rel|
       id_user = rel.user_id
       id_lo = rel.learning_object_id
       type = rel.type

       #  Nacitanie jednotlivych interakcii, pre konkretne dvojice
       if type == "UserSolvedLoRelation"
         if result.has_key?([id_user,id_lo])
           result[[id_user,id_lo]] =  "#{result[[id_user,id_lo]].to_s}1"
         else
           result[[id_user,id_lo]] = "1"
         end
       elsif type == "UserFailedLoRelation" || type == "UserDidntKnowLoRelation"
         if result.has_key?([id_user,id_lo])
           result[[id_user,id_lo]] =  "#{result[[id_user,id_lo]].to_s}0"
         else
           result[[id_user,id_lo]] = "0"
         end
       end
      end

      # Vyhodnotenie na zaklade heuristik ci student danu otazku, alebo nevie
      result.each do |r|
        if r[1].length >=3 && r[1].last(3) == "111"
          result_int[r[0]]= 1
        elsif r[1].length >=2 && r[1].last(2) == "11" && r[1].count("1") >= (r[1].count("0") - 1)
          result_int[r[0]]= 1
        elsif (r[1].last(1) == "1") && (r[1].count("1") > r[1].count("0"))
          result_int[r[0]]= 1
        elsif (r[1].last(1) == "0") && (r[1].count("1") >= (r[1].count("0") + 2))
          result_int[r[0]]= 1
        else
          result_int[r[0]]= 0
        end

      end

      result_int

    end

    def self.preproces_data_for_lo(learning_object)
      result = Hash.new
      result_int = Array.new
      relations = UserToLoRelation.where("learning_object_id = ?",learning_object.id)
      relations. each do |rel|

        #  Nacitanie jednotlivych interakcii
        if rel.type == "UserSolvedLoRelation"
          if result.has_key?(rel.user_id)
            result[rel.user_id] =  "#{result[rel.user_id].to_s}1"
          else
            result[rel.user_id] = "1"
          end
        elsif rel.type == "UserFailedLoRelation" || rel.type == "UserDidntKnowLoRelation"
          if result.has_key?(rel.user_id)
            result[rel.user_id] =  "#{result[rel.user_id].to_s}0"
          else
            result[rel.user_id] = "0"
          end
        end
      end

      # Vyhodnotenie na zaklade heuristik ci student danu otazku, alebo nevie
      result.each do |r|
        if r[1].length >=3 && r[1].last(3) == "111"
          result_int.push(1)
        elsif r[1].length >=2 && r[1].last(2) == "11" && r[1].count("1") >= (r[1].count("0") - 1)
          result_int.push(1)
        elsif (r[1].last(1) == "1") && (r[1].count("1") > r[1].count("0"))
          result_int.push(1)
        elsif (r[1].last(1) == "0") && (r[1].count("1") >= (r[1].count("0") + 2))
          result_int.push(1)
        else
          result_int.push(0)
        end
      end
      result_int
    end

  end
end