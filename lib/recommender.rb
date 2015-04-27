class Recommender

  def self.get_list (user_id, week_id)
      los = Week.find(week_id).learning_objects.uniq
      list = Hash.new
      los.each do |lo|
        list[lo.id] = 0
      end

      list
  end

  def self.get_best (user_id, week_id)
    self.get_list(user_id, week_id).first
  end

end