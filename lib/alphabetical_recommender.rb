class AlphabeticalRecommender < AbstractRecommender
  def self.get_list (user_id, week_id)

    los = self.learning_objects(week_id).sort_by {|x| x.lo_id}
    list = Hash.new
    i = 0
    los.each do |lo|
      list[lo.id] = i.to_f / los.count
      i += 1
    end

    list
  end
end