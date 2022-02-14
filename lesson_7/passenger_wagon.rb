class PassengerWagon < Wagon
  attr_reader :free_places, :occupied_places

  def initialize(places_count)
    super(:passenger, places_count)
  end
end
