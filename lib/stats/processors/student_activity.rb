# encoding: UTF-8
module Stats
  module Processors
    class StudentActivity < ProcessorCore

      sheet_name "Aktivita studentov"

      sheet_split "D2"

      def self.process(setup)

        users = User.where(role: "student")

        # ------------------------------------------------------------------

        # TODO: doplnenie headera

        # user_completed_lo_relation.rb -
        # user_didnt_know_lo_relation.rb -
        # user_visited_lo_relation.rb - pocte zobrazenych otazok v rezime ucenia,
        # user_viewed_solution_lo_relation.rb - pocte zobrazenych spravnych odpovedi v rezime prezerania,
        # - pocet doteraz spravne zodpovedanych otazok (uniq, cize ak jednu otazku zodpovedal spravne trikrat, rata sa iba raz)
        # user_solved_lo_relation.rb - pocet doteraz spravne zodpovedanych pokusov (cize ak jednu otazku zodpovedal spravne trikrat, rata sa trikrat)
        # user_failed_lo_relation.rb - pocet doteraz nespravne zodpovedanych pokusov
        # - pocet hodnoteni spravnosti (evaluator otazky)

        header =  ["Počet zobrazených otázok v režime učenia",
                   "Počet zobrazených správnych odpovedí v režime prezerania",
                   "Počet doteraz správne zodpovedaných pokusov",
                   "Počet doteraz nesprávne zodpovedaných pokusov"]

        # ------------------------------------------------------------------

        user_completed_lo = UserCompletedLoRelation.where(user_id: users, setup_id: setup.id)
        user_didnt_know_lo = UserDidntKnowLoRelation.where(user_id: users, setup_id: setup.id)
        user_visited_lo = UserVisitedLoRelation.where(user_id: users, setup_id: setup.id)
        user_viewed_solution_lo = UserViewedSolutionLoRelation.where(user_id: users, setup_id: setup.id)
        user_solved_lo = UserSolvedLoRelation.where(user_id: users, setup_id: setup.id)
        user_failed_lo = UserFailedLoRelation.where(user_id: users, setup_id: setup.id)

        table = []

        users.each do |u|
          row = [u.aisid, u.login, u.last_name, u.first_name ]

          # Počet zobrazených otázok v režime učenia
          row << user_visited_lo[[u.id]]

          # Počet zobrazených správnych odpovedí v režime prezerania
          row << user_viewed_solution_lo[[u.id]]

          # TODO: dolpnenie ďalších záznamov podľa redmine zoznamu nad header-om

          table << row
        end

        # replace nil values (not logins and names) with zeros
        table = table.map do |row|
          row[0..3] + row[4..-1].map { |x| x.nil? ? 0 : x}
        end

        # users with no name (never logged in) should be last
        table = table.sort_by { |x| (x[2].nil? || x[-2].nil?) ? 1000 : -x[-2] }

        # ------------------------------------------------------------------

        return [header, table]
      end

    end
  end
end
