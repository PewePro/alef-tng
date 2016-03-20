# Rozsirujuce metody pre Hash.
class Hash

  # Vynuti zoznam klucov v hashi.
  # @param keys[Array] zoznam klucov, ktore treba vysetrit
  def require_keys(*keys)
    keys.each do |key|
      raise Exceptions::MissingKeyError.new(key) unless self.key?(key)
    end
    self
  end

end