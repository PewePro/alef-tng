require 'csv'

namespace :alef do
  namespace :users do
    task :import_groups, [:group_csv] => :environment do |t, args|
      CSV.read(args.group_csv, headers: false, col_sep: "\t").each do |row|
        aisid = row[0]
        login = row[1]
        group = row[2]

        next unless login

        u = LdapUser.find_or_create_by(login: login) do |u|
          u.aisid = aisid
        end
        u.group = group
        u.save!
      end
    end

    # sets involved_in_gamification for existing users (or creates them) based on input CSV in the form of:
    #
    # AIS ID;login;gamifikacia
    # 12345;xpriezvisko;A
    # 67890;xpriezviskoine;N
    task :import_gamification_settings, [:gamification_csv] => :environment do |t, args|
      c_yes = 0
      c_no = 0
      c_new = 0
      CSV.read(args.gamification_csv, headers: true, col_sep: ';').each do |row|
        aisid = row['AIS ID']
        login = row['login']
        gamification = (row['gamifikacia']=='A')

        next unless login

        u = LdapUser.find_or_create_by(login: login) do |u|
          c_new += 1
          u.aisid = aisid
        end
        raise "AIS ID mismatch for user: #{row}" if u.aisid && u.aisid != aisid

        u.involved_in_gamification = gamification
        u.save!

        if gamification
          c_yes += 1
        else
          c_no += 1
        end
      end

      puts "#{c_new} new users created. Set #{c_yes} users to have gamification, #{c_no} to not have."
    end
  end
end