module RoomHelper

  # Vrati pocet videnych otazok v danej miestnosti
  def views_los(results,lo)
    result = results.find {|r| r["result_id"] == lo.id.to_s}
    view = result['visited'] unless result.nil?
    view
  end

  # Vrati pocet spravne zodpovedanych otazok v danje miestnosti
  def done_los(results,lo)
    result = results.find {|r| r["result_id"] == lo.id.to_s}
    done = result['solved'] unless result.nil?
    done
  end

  # Vytvori a vrati popis danej miestnosti na zaklade najpouzivanejsich konceptov
  def get_description(room)
    lo = room.learning_objects.shuffle.first
    description = "Zastúpené témy: "
    list = Array.new

    concepts = lo.concepts
    concepts.each do |c|
        if list.count < Room::NUMBER_OF_CONCEPTS_IN_DESCRIPTION
          list.push(c.name)
        end
      if list.count == Room::NUMBER_OF_CONCEPTS_IN_DESCRIPTION
        break
      end
    end

    list.each do |li|
      description += "#{li}, "
    end

    "#{description[0..description.size-3]}."
    end
end
