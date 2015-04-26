class RecommenderOption < ActiveRecord::Base
  has_one :recommender
  has_one :recommendations_configuration
end