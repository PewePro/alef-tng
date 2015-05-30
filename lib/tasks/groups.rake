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
  end
end