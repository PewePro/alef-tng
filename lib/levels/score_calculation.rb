module Levels
  # Trieda sluzi na vytvorenie miestnosti
  class ScoreCalculation
    # Metoda vypocita hranicne skore pre danu miestnost
    def self.compute_limit_score(number_lo, learning_objects,setup)

      number_questions = number_lo * Constants::MIN_PERCENTAGE_OF_SUCCESS

      sum_dif = 0.0
      sum_imp = 0.0

      learning_objects.each do |l|
        dif_result = l.get_difficulty(setup)
        sum_dif += dif_result
        imp_value = l.get_importance
        sum_imp += imp_value
      end

      avg_dif = sum_dif / number_lo.to_f
      avg_imp = sum_imp / number_lo.to_f

      number_questions * Constants::WEIGHT_SOLVED * avg_imp * avg_dif
    end

    # Metoda vypocita skore pre poslednu odpoved studenta na otazku
    def self.compute_score_for_question(room,params,current_user)
      setup = Setup.take
      lo_class = Object.const_get params[:type]
      lo = lo_class.find(params[:id])
      solution = lo.get_solution(current_user.id)

      results_used = UserToLoRelation.get_results_room(current_user.id,params[:week_number],params[:room_number], room.number_of_try,lo.id).try(:first)
      used = FALSE
      used = results_used && (results_used["solved"] || results_used["failed"] || results_used["donotnow"])

      if params[:commit] == 'send_answer'
        result = lo.right_answer?(params[:answer], solution)
      end

      # Nacitanie parametrov  obtiaznosti a dolezitosti danej otazky
      dif_result = lo.get_difficulty(setup)
      imp_value = lo.get_importance

      score = 0.0

      if lo.is_a?(EvaluatorQuestion)
        # V pripade, ze dana otazka je typu evaluator, spravnost sa vypocita ako vzdialenost od priemeru odpovedi
        solution = lo.get_solution(current_user.id)
        if solution.nil?
          rightness = 1
        else
          rightness = 1 - ((solution - params[:answer].to_i).abs)/100
        end
        score = Constants::WEIGHT_SOLVED * rightness * imp_value * dif_result
      else
        if results_used.nil? || !used
          if params[:commit] == 'dont_know'
            score = Constants::WEIGHT_DONT_NOW * imp_value *dif_result
          elsif (params[:commit] == 'send_answer' && result)
            score = Constants::WEIGHT_SOLVED * imp_value * dif_result
          elsif (params[:commit] == 'send_answer' && !result)
            score = Constants::WEIGHT_FAILED * imp_value * dif_result
          end
        end
      end

      score
    end

    # Metoda vypocita skore za komentare v prislusnej miestnosti a pre konkretneho studenta
    def self.compute_score_for_comments(learning_objects,setup,current_user)
      score = 0.0

      learning_objects.eager_load(:feedbacks).where("feedbacks.visible = ?", true).each do |l|
        order_to_comment = 0  # Poradie prispevku pri learning objecte
        order_to_comment_of_user = 0 # Poradie prispevku medzi konkretnym pouzivatelom a konkretnym learning objectom
        l.feedbacks.each do |f|
          order_to_comment += 1

          if f.user_id == current_user.id
            order_to_comment_of_user += 1

            # Ziskanie prametrov narocnosti a dolezisto daneho learning objectu
            dif_result = l.get_difficulty(setup)
            imp_value = l.get_importance

            # Vypocet skore za komentare ako sucet ciastkovych skor za jednotlive komentare
            # Skore za komentar predstavuje sucin vahy za komentar, dolezitosti otazky, narocnosti otazky, znizenia za poradie pripsevku pri danej otazke a znizenia za poradie prispevku studenta pri danej otazke
            # Znizenia za poradie pripsevku pri danej otazke - tazsie napisat 1. nez x-ty komentar
            # Znizenia za poradie prispevku studenta pri danej otazkeznizenia za poradie prispevku studenta pri danej otazke - Prispevok ku skore sa za komentare pod jednou otazkou znizuje

            score = score + Constants::WEIGHT_COMMENT * dif_result * imp_value * (Constants::BASE_EXP_FUNCTION ** order_to_comment) * (Constants::BASE_EXP_FUNCTION ** order_to_comment_of_user)
          end
        end
      end
      score
    end
  end
end


