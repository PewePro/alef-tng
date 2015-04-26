class RecommendationConfiguration < ActiveRecord::Base
  has_many :recommender_options
  has_many :recommendation_linkers
end