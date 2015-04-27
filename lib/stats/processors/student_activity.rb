# encoding: UTF-8
module Stats
  module Processors
    class StudentActivity < ProcessorCore

      sheet_name "Aktivita studentov"

      sheet_split "D3"

      CREDENTIALS = ["AISID", "Login", "Priezvisko", "Meno", ]
      METRICS_HEADER = ["Návštevy (uč.)",       #"Počet zobrazených otázok",
                        "Návštevy (test.)",     #"Počet zobrazených správnych odpovedí",
                        "Evaluator",            #"Počet hodnotení otázok type Evaluation",
                        "Správne (unikátne)",   #"Počet doteraz správne zodpovedaných otázok",
                        "Správne",              #"Počet doteraz správne zodpovedaných pokusov",
                        "Nesprávne",            #"Počet doteraz nesprávne zodpovedaných pokusov",
                        "Neviem",               #"Počet kliknutí na odpoveď Neviem",
                        "Pozn."                 #"Počet vložených poznámok"
                       ]

      def self.week_start(setup, week)
        setup.first_week_at.to_date + week.number * 7 - 7
      end

      def self.get_weeks(setup)
        right_weeks = []
        all_weeks = setup.weeks.order(:number).reverse_order
        all_weeks.each do |aw|
          #puts "WEEK (aw): #{aw.id} , #{aw.number} WEEK_END: #{(week_start(setup,aw)+6)} TIME_NOW: #{Time.now.to_date}"
          if (week_start(setup,aw)) <= Time.now.to_date
            #puts "WEEK_ID: #{aw.id}"
            right_weeks << aw
          end
        end
        return right_weeks
      end

      def self.process(setup)

        # TODO
        # Testovacia verzia
        su = User.all
        su_map = su.map(&:id)
        users = User.where(id: su_map)

        # Realna verzia
        #setup = Setup.find_by_id(setup.id)
        #su = setup.users.all
        #s_map = su.map(&:id)
        #users = User.where(id: s_map)

        # ------------------------------------------------------------------

        weeks = get_weeks(setup)
        #weeks.map {|w2| puts "W2: #{w2.id} , #{w2.number}"}

        choiceID = LearningObject.select(:id).where.not(type: "EvaluatorQuestion").all
        evalID = LearningObject.select(:id).where(type: "EvaluatorQuestion").all

        header = []
        header << [""] * CREDENTIALS.length +
                  ["SEMESTER"] * METRICS_HEADER.length +
                  weeks.map { |x|
                  ["#{week_start(setup,x).strftime("%d.%m.")}-#{(week_start(setup,x) + 6).strftime("%d.%m. %H:%M")}"] * METRICS_HEADER.length
                  }.flatten

        header <<  CREDENTIALS + METRICS_HEADER * (weeks.length + 1)

        # ------------------------------------------------------------------

        credentials_splitters = [nil] * CREDENTIALS.length
        credentials_splitters[-1] = 1

        stats_splitters = [nil, nil, nil, nil, nil, nil, nil, 1]

        weeks_splitters = (stats_splitters) * weeks.length

        splitters =  credentials_splitters + weeks_splitters + stats_splitters


        mergers = []
        y = 0
        (weeks.length + 1).times do |i|
          first = CREDENTIALS.length + i*METRICS_HEADER.length
          last = first + (METRICS_HEADER.length - 1)

          mergers << [first, y, last, y]
        end

        # ------------------------------------------------------------------

        user_visited_lo_weeks = weeks.map do |w|
          UserVisitedLoRelation.where(user_id: users, setup_id: setup.id, :created_at => (week_start(setup,w))..(week_start(setup,w) + 7)).group(:user_id).count(:id)
        end
        user_viewed_solution_lo_weeks = weeks.map do |w|
          UserViewedSolutionLoRelation.where(user_id: users, setup_id: setup.id, :created_at => (week_start(setup,w))..(week_start(setup,w) + 7)).group(:user_id).count(:id)
        end
        user_rate_eval_lo_weeks = weeks.map do |w|
          UserSolvedLoRelation.where(user_id: users, setup_id: setup.id, learning_object_id: evalID, :created_at => (week_start(setup,w))..(week_start(setup,w) + 7)).group(:user_id).count(:id)
        end
        user_solved_uniq_lo_weeks = weeks.map do |w|
          UserSolvedLoRelation.where(user_id: users, setup_id: setup.id, learning_object_id: choiceID, :created_at => (week_start(setup,w))..(week_start(setup,w) + 7)).group(:user_id).count('distinct learning_object_id')
        end
        user_solved_lo_weeks = weeks.map do |w|
          UserSolvedLoRelation.where(user_id: users, setup_id: setup.id, learning_object_id: choiceID, :created_at => (week_start(setup,w))..(week_start(setup,w) + 7)).group(:user_id).count(:id)
        end
        user_failed_lo_weeks = weeks.map do |w|
          UserFailedLoRelation.where(user_id: users, setup_id: setup.id, learning_object_id: choiceID, :created_at => (week_start(setup,w))..(week_start(setup,w) + 7)).group(:user_id).count(:id)
        end
        user_didnt_know_lo_weeks = weeks.map do |w|
          UserDidntKnowLoRelation.where(user_id: users, setup_id: setup.id, :created_at => (week_start(setup,w))..(week_start(setup,w) + 7)).group(:user_id).count(:id)
        end
        user_feedback_weeks = weeks.map do |w|
          Feedback.where(user_id: users, :created_at => (week_start(setup,w))..(week_start(setup,w) + 7)).group(:user_id).count(:id)
        end

        table = []

        users.each do |u|
          row_start = [u.aisid, u.login, u.last_name, u.first_name]
          row_rest = []

          sum_user_visited_lo = 0
          sum_user_viewed_solution_lo = 0
          sum_user_rate_eval_lo = 0
          sum_user_solved_uniq_lo = 0
          sum_user_solved_lo = 0
          sum_user_failed_lo = 0
          sum_user_didnt_know_lo = 0
          sum_user_feedback = 0

          [user_visited_lo_weeks, user_viewed_solution_lo_weeks, user_rate_eval_lo_weeks,
           user_solved_uniq_lo_weeks, user_solved_lo_weeks, user_failed_lo_weeks,
           user_didnt_know_lo_weeks, user_feedback_weeks].transpose.
          each do | user_visited_lo, user_viewed_solution_lo, user_rate_eval_lo,
                    user_solved_uniq_lo, user_solved_lo, user_failed_lo,
                    user_didnt_know_lo, user_feedback |

            uvlo = user_visited_lo[u.id]
            uvlo ||= 0
            uvslo = user_viewed_solution_lo[u.id]
            uvslo ||= 0
            urelo = user_rate_eval_lo[u.id]
            urelo ||= 0
            usulo = user_solved_uniq_lo[u.id]
            usulo ||= 0
            uslo = user_solved_lo[u.id]
            uslo ||= 0
            uflo = user_failed_lo[u.id]
            uflo ||= 0
            udklo = user_didnt_know_lo[u.id]
            udklo ||= 0
            uf = user_feedback[u.id]
            uf ||= 0

            row_rest << uvlo    # Počet zobrazených otázok
            row_rest << uvslo   # Počet zobrazených správnych odpovedí
            row_rest << urelo   # Počet hodnotení otázok typu Evaluation
            row_rest << usulo   # Počet doteraz správne zodpovedaných otázok
            row_rest << uslo    # Počet doteraz správne zodpovedaných pokusov
            row_rest << uflo    # Počet doteraz nesprávne zodpovedaných pokusov
            row_rest << udklo   # Počet kliknutí na odpoveď Neviem
            row_rest << uf      # Počet vložených poznámok

            sum_user_visited_lo += uvlo
            sum_user_viewed_solution_lo += uvslo
            sum_user_rate_eval_lo += urelo
            sum_user_solved_uniq_lo += usulo
            sum_user_solved_lo += uslo
            sum_user_failed_lo += uflo
            sum_user_didnt_know_lo += udklo
            sum_user_feedback += uf

          end

          row_start << sum_user_visited_lo
          row_start << sum_user_viewed_solution_lo
          row_start << sum_user_rate_eval_lo
          row_start << sum_user_solved_uniq_lo
          row_start << sum_user_solved_lo
          row_start << sum_user_failed_lo
          row_start << sum_user_didnt_know_lo
          row_start << sum_user_feedback

          table << (row_start + row_rest)
        end

        # ------------------------------------------------------------------

        return [header, table, splitters, mergers]
      end

    end
  end
end
