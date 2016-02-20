# Rozsirenie nad mnozinou, ktore sluzi na zapamatanie si poslednych N poloziek.
class MemorySet

  # @param id [String] jedinecny identifikator memory setu
  # @param _session [] relacia Railsu
  # @param size [Integer] maximalna velkost mnoziny (N)
  def initialize(id, _session, size)

    @id = id
    @session = _session
    @session[:memory_sets] ||= {}
    @size = size
    @set = @session[:memory_sets].has_key?(id) ? @session[:memory_sets][id] : []

  end

  # Prida novy prvok.
  def << (element)
    @set << element
    @set.shift if @set.size > @size
    save
  end

  # Ziska zoznam vsetkych prvkov.
  def get
    @set
  end

  # Vycisti vsetky prvky memory setu.
  def clear
    @set = []
    save
  end

  private

  # Ulozi zmeny do session.
  def save
    @session[:memory_sets][@id] = @set
  end

end