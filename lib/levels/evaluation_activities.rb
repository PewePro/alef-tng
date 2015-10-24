module Levels
  class EvaluationActivities
    def self.activity(number_of_questions,learning_objects, current_user, results)
     weight_solved = 5
     weight_failed = 2
     weight_dont_now = 1
     weight_comment = 3
     weight_like = 1
     weight_dislike = 1

     score1 = 0
     score2 =0
     learning_objects.each do |l|
       feedbacks = l.feedbacks
       feedbacks.each do |f|
         if f.user_id == current_user.id
           score1 = score1.to_f + weight_comment
         end
       end

       solved = 0
       failed = 0
       donotnow = 0
       result = results.find {|r| r["result_id"] == l.id.to_s}
       unless result.nil?
         solved = result['solved']
         failed = result['failed']
         donotnow = result['donotnow']
       end
       if solved.to_i > 0
         score2 = score2.to_f + weight_solved
       elsif failed.to_i > 0
         score2 = score2.to_f + weight_failed
       elsif donotnow.to_i > 0
         score2 = score2.to_f + weight_dont_now
       end
     end

     (score1 + score2).round(2)
    end


  end
end