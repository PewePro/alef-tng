class RecommendationLinker < ActiveRecord::Base
  belongs_to :week
  belongs_to :user
  belongs_to :recommendation_configuration
end