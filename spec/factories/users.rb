# Definicia tovarniciek pre pouzivatelov.
FactoryGirl.define do

  factory :user, class: LocalUser do
    first_name "Student"
    last_name  "Premudrely"
    role User::ROLES[:STUDENT]
    type "LocalUser"
    login "mudrc1"
    password "lenivec123"
  end

  factory :admin, class: LocalUser do
    first_name "Administrator"
    last_name  "Administratorovy"
    role User::ROLES[:ADMINISTRATOR]
    type "LocalUser"
    login "admin1"
    password "bezpecnost123"
  end

end