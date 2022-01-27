class Route
  attr_reader :stations

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
  end

  def add_station(station)
    self.stations.insert(-2, station)
  end

  def remove_station(station)
    return if station == stations.first || station == stations.last

    stations.delete(station)
  end

  def see_route
    stations.each_with_index {|station, index| puts "#{index}. #{station.name}"}
  end
end
