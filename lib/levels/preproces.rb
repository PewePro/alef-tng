module Levels
  class Preproces
    def self.preproces_data(setup)
      result = Hash.new
      result_int = Hash.new
      relations = setup.user_to_lo_relations

      relations. each do |rel|
       id_user = rel.user_id.to_i
       id_lo = rel.learning_object_id.to_i
       type = rel.type.to_s
       if type.to_s == "UserSolvedLoRelation"
         if result.has_key?([id_user,id_lo])
           result[[id_user,id_lo]] =  result[[id_user,id_lo]].to_s + "1"
         else
           result[[id_user,id_lo]] = "1"
         end
       elsif type.to_s == "UserFailedLoRelation" || type.to_s == "UserDidntKnowLoRelation"
         if result.has_key?([id_user,id_lo])
           result[[id_user,id_lo]] =  result[[id_user,id_lo]].to_s + "0"
         else
           result[[id_user,id_lo]] = "0"
         end
       end
      end

      result.each do |r|
        if r[1].to_s.length >=3 && r[1].to_s.last(3) == "111"
          result_int[r[0]]= 1
        elsif r[1].to_s.length >=2 && r[1].to_s.last(2) == "11" && r[1].to_s.count("1") >= (r[1].to_s.count("0").to_i - 1)
          result_int[r[0]]= 1
        elsif (r[1].to_s.last(1) == "1") && (r[1].to_s.count("1") > r[1].to_s.count("0"))
          result_int[r[0]]= 1
        elsif (r[1].to_s.last(1) == "0") && (r[1].to_s.count("1") >= (r[1].to_s.count("0").to_i + 2))
          result_int[r[0]]= 1
        else
          result_int[r[0]]= 0
        end

      end

      result_int

    end
  end
end