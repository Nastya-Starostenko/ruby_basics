class Train
  attr_reader :number, :route, :speed, :car_count, :next_station, :previous_station, :current_station, :type

  private
  attr_writer :number, :route, :speed, :car_count, :next_station, :previous_station, :current_station, :type

  def initialize(type, car_count)
    @number = rand(100)
    @car_count = car_count
    @type = type
    @speed = 0
  end

  public

  def add_train(train)
    @trains << train
  end

  def pick_up_speed
    self.speed += 20
  end

  def slow_down
    self.speed = 0
  end

  def change_car_count(value)
    return if speed != 0

    self.car_count += value
    self.car_count = 0 if car_count < 0
  end

  def index_of_current_station
    route.stations.index(current_station)
  end

  def add_route(route)
    self.route = route
    self.current_station = route.first_station
    self.next_station = route.stations[1]

    current_station.add_train(self)
  end

  def move_to_next_station
    return 'There is terminal station' if next_station.nil?

    self.previous_station = current_station
    self.current_station = next_station
    index = index_of_current_station + 1
    self.next_station = index <= route.stations.count ? route.stations[index] : nil

    previous_station.train_departure(self)
    current_station.add_train(self)

    puts "Current station is #{current_station.name} and has trains #{current_station.trains.count}"
  end

  def move_to_previous_station
    return 'There is the first station' if previous_station.nil?

    self.next_station = current_station
    self.current_station = previous_station
    index = index_of_current_station - 1
    self.previous_station = index >= 0 ? route.stations[index] : nil

    next_station.train_departure(self)
    current_station.add_train(self)

    puts "Current station is #{current_station.name} and has trains #{current_station.trains.count}"
  end
end
