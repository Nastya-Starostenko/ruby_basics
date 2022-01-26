class Route
  attr_reader :first_station, :last_station, :stations

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @stations = [first_station, last_station]
  end

  def add_station(station)
    self.stations.insert(-2, station)
  end

  def remove_station(station)
    return if station == first_station || station == last_station

    stations.delete(station)
  end

  def see_route
    stations.each_with_index {|station, index| puts "#{index}. #{station.name}"}
  end
end
