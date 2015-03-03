class SetupsUser < ActiveRecord::Base
  belongs_to :setup
  belongs_to :user
end