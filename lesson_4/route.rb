class Route
  attr_reader :stations, :number

  def initialize(first_station, last_station, stations = [])
    @stations = [first_station, last_station]
    @number = rand(36**3)
    stations&.each { |station| add_station(station) }
  end

  def add_station(station)
    self.stations.insert(-2, station)

    puts "Station was added, new route: #{see_route}"
  end

  def remove_station(station)
    return if station == stations.first || station == stations.last

    stations.delete(station)
    puts "Station was deleted, new route: #{see_route}"
  end

  def info
    "Number: #{number}, route: #{stations.map(&:name).join(',')}"
  end
end
