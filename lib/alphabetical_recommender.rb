class AlphabeticalRecommender < Recommender
  def self.get_list (user_id, week_id)

    los = Week.find(week_id).learning_objects.uniq.sort_by {|x| x.lo_id}
    list = Hash.new
    i = 0
    los.each do |lo|
      list[lo.id] = i
      i += 1
    end

    list
  end
end