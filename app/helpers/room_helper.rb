module RoomHelper

  # Vrati pocet videnych otazok v danej miestnosti
  def views_los(results,lo)
    result = results.find {|r| r["result_id"] == lo.id.to_s}
    unless result.nil?
      view = result['visited']
    end
    view
  end

  # Vrati pocet spravne zodpovedanych otazok v danje miestnosti
  def done_los(results,lo)
    result = results.find {|r| r["result_id"] == lo.id.to_s}
    unless result.nil?
      done = result['solved']
    end
    done
  end

  # Vytvori a vrati popis danej miestnosti na zaklade najpouzivanejsich konceptov
  def get_description(room)
    los = room.learning_objects.eager_load(:concepts)
    description = "Najviac zastúpené témy: "
    number = 5
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
    description += list.take(number).map{ |key, value| "#{key} => #{value}-krat"}.join(', ') + '.'

    description
  end
end
