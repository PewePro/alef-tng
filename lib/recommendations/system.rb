class RecommendationSystem

  def get_list (user_id, week_id)
    # get recommendation config
    # compute all recs
    # reduce and return
  end

  def get_best (user_id, week_id)
    self.get_list(user_id, week_id).first
  end

end