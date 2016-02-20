require "rails_helper"

describe Core::MemorySet do

  describe "basic_test" do

    it "should add recent visits correctly" do

      memory_set = Core::MemorySet.new(:test, {}, 5)

      [1, 2, 3, 4, 5].each do |element|
        memory_set << element
      end

      expect(memory_set.get.size).to eq(5)
      expect(memory_set.get).to match_array([1, 2, 3, 4, 5])

      # Pridame dalsi prvok, cize by mal vypadnut prvy.
      memory_set << 9
      expect(memory_set.get.size).to eq(5)
      expect(memory_set.get).to match_array([2, 3, 4, 5, 9])

      # Vycistenie.
      memory_set.clear
      expect(memory_set.get.size).to eq(0)

    end

  end

end