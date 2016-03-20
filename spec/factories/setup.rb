# Definicia tovarniciek pre zaklade informacie o predmetoch.
FactoryGirl.define do

  factory :course do
    name 'Ultrauzasny predmet'
  end

  factory :setup do
    name 'Ultrauzasny predmet'
    first_week_at Time.now - 5.days
  end

  factory :week do
    number 1
  end

end