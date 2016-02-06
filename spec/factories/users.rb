# Definicia tovarniciek pre pouzivatelov.
FactoryGirl.define do

  factory :user, class: LocalUser do
    first_name "Student"
    last_name  "Premudrely"
    role "student"
    type "LocalUser"
    login "mudrc1"
    password "lenivec123"
  end

  factory :admin, class: LocalUser do
    first_name "Administrator"
    last_name  "Administratorovy"
    string "admin1"
    role "admin"
    type "LocalUser"
    password "bezpecnost123"
  end

end