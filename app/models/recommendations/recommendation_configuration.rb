class RecommendationConfiguration < ActiveRecord::Base
  has_many :recommenders_options
  has_many :recommendation_linkers
end