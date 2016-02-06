# Definicia tovarniciek pre pouzivatelov.
FactoryGirl.define do

  factory :user do
    first_name "Student"
    last_name  "Premudrely"
    role "student"
    type "LocalUser"
    login "mudrc1"
    encrypted_password "lenivec123"
  end

  factory :admin, class: User do
    first_name "Administrator"
    last_name  "Administratorovy"
    string "admin1"
    role "admin"
    type "LocalUser"
    encrypted_password "bezpecnost123"
  end

end