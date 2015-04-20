# encoding: UTF-8
module Stats
  module Processors
    class StudentActivity < ProcessorCore

      sheet_name "Aktivita studentov"

      sheet_split "D2"

      def self.process(setup)

        su = User.where(role: "teacher")
        su_map = su.map(&:id)
        users = User.where(id: su_map)

        #su = SetupsUser.find_by_setup_id(setup.id)
        #su_map = su.map(&:user_id)
        #users = User.where(id: su_map)

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

        header =  ["AISID", "Login", "Priezvisko", "Meno",
                   "Počet zobrazených otázok v režime učenia",
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
          uvlo = user_visited_lo.where(user_id: u)
          row << uvlo.count if uvlo

          # Počet zobrazených správnych odpovedí v režime prezerania
          ucslo = user_viewed_solution_lo.where(user_id: u)
          row << ucslo.count if ucslo

          # Počet doteraz správne zodpovedaných pokusov
          uslo = user_solved_lo.where(user_id: u)
          row << uslo.count if uslo

          # Počet doteraz nesprávne zodpovedaných pokusov
          uflo = user_failed_lo.where(user_id: u)
          row << uflo.count if uflo

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
