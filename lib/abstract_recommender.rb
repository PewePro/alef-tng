class AbstractRecommender

  @@los = Hash.new
  def self.learning_objects (week_id)
    if @@los[week_id].nil?
      @@los[week_id] = Week.find(week_id).learning_objects.uniq
    end

    @@los[week_id]
  end

  def self.get_list (user_id, week_id)
      los = self.learning_objects(week_id)
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