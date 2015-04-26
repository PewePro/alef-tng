# encoding: UTF-8
module Stats
  module Processors
    class StudentActivity < ProcessorCore

      sheet_name "Aktivita studentov"

      sheet_split "D2"

      CREDENTIALS = ["AISID", "Login", "Priezvisko", "Meno", ]
      METRICS_HEADER = ["Počet zobrazených otázok",
                        "Počet zobrazených správnych odpovedí",
                        "Počet doteraz správne zodpovedaných pokusov",
                        "Počet doteraz nesprávne zodpovedaných pokusov",
                        "Počet doteraz správne zodpovedaných otázok",
                        "Počet kliknutí na odpoveď Neviem"]

      def self.week_start(setup, week)
        setup.first_week_at.to_date + week.number * 7 - 7
      end

      def self.process(setup, week)

        # Testovacia verzia
        su = User.where(role: "teacher")
        su_map = su.map(&:id)
        users = User.where(id: su_map)

        # Realna verzia
        #setup = Setup.find_by_id(setup.id)
        #su = setup.users.all
        #s_map = su.map(&:id)
        #users = User.where(id: su_map)

        # ------------------------------------------------------------------

        weeks = setup.weeks.order(:number)

        header = []
        header << [""] * CREDENTIALS.length +
                  ["--SEMESTER--"] * METRICS_HEADER.length +
                  weeks.map { |x|
                  ["#{week_start(setup,x).strftime("%d.%m.")}-#{(week_start(setup,x) + 6).strftime("%d.%m. %H:%M")}"] * METRICS_HEADER.length
                  }.flatten

        header <<  CREDENTIALS + METRICS_HEADER * (weeks.length + 1)

        # ------------------------------------------------------------------

        credentials_splitters = [nil] * CREDENTIALS.length
        credentials_splitters[-1] = 1

        stats_splitters = [nil, nil, nil, nil, nil, 1]

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

        user_didnt_know_lo_weeks = weeks.map do |w|
          UserDidntKnowLoRelation.where(user_id: users, setup_id: setup.id, :created_at => (week_start(setup,w))..(week_start(setup,w) + 6)).group(:user_id).count(:id)
        end
        user_visited_lo_weeks = weeks.map do |w|
          UserVisitedLoRelation.where(user_id: users, setup_id: setup.id, :created_at => (week_start(setup,w))..(week_start(setup,w) + 6)).group(:user_id).count(:id)
        end
        user_viewed_solution_lo_weeks = weeks.map do |w|
          UserViewedSolutionLoRelation.where(user_id: users, setup_id: setup.id, :created_at => (week_start(setup,w))..(week_start(setup,w) + 6)).group(:user_id).count(:id)
        end
        user_solved_lo_weeks = weeks.map do |w|
          UserSolvedLoRelation.where(user_id: users, setup_id: setup.id, :created_at => (week_start(setup,w))..(week_start(setup,w) + 6)).group(:user_id).count(:id)
        end
        user_solved_uniq_lo_weeks = weeks.map do |w|
          UserSolvedLoRelation.where(user_id: users, setup_id: setup.id, :created_at => (week_start(setup,w))..(week_start(setup,w) + 6)).group(:user_id).count('distinct learning_object_id')
        end
        user_failed_lo_weeks = weeks.map do |w|
          UserFailedLoRelation.where(user_id: users, setup_id: setup.id, :created_at => (week_start(setup,w))..(week_start(setup,w) + 6)).group(:user_id).count(:id)
        end

        table = []

        users.each do |u|
          row_start = [u.aisid, u.login, u.last_name, u.first_name]
          row_rest = []

          sum_user_visited_lo = 0
          sum_user_viewed_solution_lo = 0
          sum_user_solved_lo = 0
          sum_user_failed_lo = 0
          sum_user_solved_uniq_lo = 0
          sum_user_didnt_know_lo = 0

          [user_visited_lo_weeks, user_viewed_solution_lo_weeks, user_solved_lo_weeks,
           user_failed_lo_weeks, user_solved_uniq_lo_weeks, user_didnt_know_lo_weeks].transpose.
          each do | user_visited_lo, user_viewed_solution_lo, user_solved_lo,
                    user_failed_lo, user_solved_uniq_lo, user_didnt_know_lo |

            uvlo = user_visited_lo[u.id]
            uvlo ||= 0
            uvslo = user_viewed_solution_lo[u.id]
            uvslo ||= 0
            uslo = user_solved_lo[u.id]
            uslo ||= 0
            uflo = user_failed_lo[u.id]
            uflo ||= 0
            usulo = user_solved_uniq_lo[u.id]
            usulo ||= 0
            udklo = user_didnt_know_lo[u.id]
            udklo ||= 0

            row_rest << uvlo    # Počet zobrazených otázok
            row_rest << uvslo   # Počet zobrazených správnych odpovedí
            row_rest << uslo    # Počet doteraz správne zodpovedaných pokusov
            row_rest << uflo    # Počet doteraz nesprávne zodpovedaných pokusov
            row_rest << usulo   # Počet doteraz správne zodpovedaných otázok
            row_rest << udklo   # Počet kliknutí na odpoveď Neviem

            sum_user_visited_lo += uvlo
            sum_user_viewed_solution_lo += uvslo
            sum_user_solved_lo += uslo
            sum_user_failed_lo += uflo
            sum_user_solved_uniq_lo += usulo
            sum_user_didnt_know_lo += udklo

          end

          row_start << sum_user_visited_lo
          row_start << sum_user_viewed_solution_lo
          row_start << sum_user_solved_lo
          row_start << sum_user_failed_lo
          row_start << sum_user_solved_uniq_lo
          row_start << sum_user_didnt_know_lo

          table << (row_start + row_rest)
        end

        # ------------------------------------------------------------------

        return [header, table, splitters, mergers]
      end

    end
  end
end
