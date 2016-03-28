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
    los = room.learning_objects.eager_load(:concepts)
    description = "Najviac zastúpené témy: "
    list = Hash.new

    los.each do |l|
      l.concepts.each do |c|
        if list.has_key?(c.name)
          list[c.name] = list[c.name] + 1
        else
          list[c.name] = 1
        end
      end
    end

    list = list.sort_by{|_key, value| value}.reverse.to_h
    description += list.take(Room::NUMBER_OF_CONCEPTS_IN_DESCRIPTION).map{ |key, value| "#{key} => #{value}-krat"}.join(', ') + '.'

    description
  end
end
