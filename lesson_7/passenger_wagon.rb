class PassengerWagon < Wagon
  attr_reader :free_places, :occupied_places

  def initialize(places_count)
    @places_count = places_count
    @free_places = places_count
    @occupied_places = 0
    super(:passenger)
  end
  
  def take_the_place
    raise "Wagon doesn`t have free places" if free_places.zero?

    self.occupied_places += 1
    self.free_places -= 1

  end

  private

  attr_accessor :places_count
  attr_writer :free_places, :occupied_places
end
