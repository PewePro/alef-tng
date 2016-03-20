# Definicia tovarniciek pre vzdelavacie objekty.
FactoryGirl.define do

  factory :learning_object, class: LearningObject do
    lo_id 'Mena faktur stratenych'
    question_text 'Vrati sa niektora z nich?'
    type 'SingleChoiceQuestion'
  end

  factory :another_learning_object, class: LearningObject do
    lo_id 'Predpoved pocasia'
    question_text 'Ake bude dnes pocko?'
    type 'SingleChoiceQuestion'
  end

end