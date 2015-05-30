class RecommendersOption < ActiveRecord::Base
  belongs_to :recommender
  belongs_to :recommendations_configuration
end