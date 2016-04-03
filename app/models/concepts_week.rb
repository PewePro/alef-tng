class ConceptsWeek < ActiveRecord::Base
  belongs_to :concept
  belongs_to :week
end