require_relative 'route.rb'
require_relative 'train.rb'
require_relative 'passenger_train.rb'
require_relative 'cargo_train.rb'
require_relative 'station.rb'
require_relative 'wagon.rb'
require_relative 'cargo_wagon.rb'
require_relative 'passenger_wagon.rb'
require_relative 'manufacturer.rb'
require_relative 'instance_counter.rb'



class Main
  attr_accessor :stations, :routes, :wagons, :trains

  def initialize
    @stations = []
    @routes = []
    @wagons = []
    @trains = []
  end

  def set_values
    stations << Station.new('Odessa')
    stations << Station.new('Kharkiv')
    stations << Station.new('Kiev')
    routes << Route.new(stations.first, stations.last)
    wagons << CargoWagon.new
    trains << CargoTrain.new([wagons.first], rand(36**6).to_s(36))
  end

  def start
    loop do
      menu.each_with_index { |action, index| puts "Put #{index + 1} for #{action}" }
      puts 'Put 0 for exit'

      input = gets.to_i
      break if input == 0

      case input
      when 1 then create_new_train
      when 2 then create_station
      when 3 then create_route
      when 4 then edit_route
      when 5 then add_route_for_train
      when 6 then add_wagon_for_train
      when 7 then remove_wagon_from_train
      when 8 then move_train_forvard
      when 9 then move_train_back
      when 10 then stations_info
      when 11 then show_trains_on_the_station
      else
        "Error: menu has an invalid value"
      end
    end
  end

  private

  def menu
    ['create new train',
     'create new station',
     'create new route',
     'edit route',
     'add route for train',
     'add wagon to train',
     'remove wagon from train',
     'move train forward',
     'move train back',
     'show list of station',
     'show trains on the station'
    ]
  end

  def create_new_train
    puts '1 - create cargo train'
    puts '2 - create passanger train'
    puts '0 - back to previous menu'

    input = gets.to_i

    case input
    when 1 then create_train(:passenger)
    when 2 then create_train(:cargo)
    when 0 then back_to_menu
    else
      "Error: menu has an invalid value"
    end

    back_to_menu
  end

  def create_train(type)
    puts 'Put train name or put 0 for random value'
    number = gets.to_s
    wagons = create_wagons_by_type(type)
    train_number = number == "0" ? "#{rand(36**3).to_s(36)}-#{rand(10..99)}" : number
    begin
      new_train = type == :passenger ? PassengerTrain.new(wagons, train_number) : CargoTrain.new(wagons, train_number)
      trains << new_train
    rescue StandardError => e
      puts "Exeption: #{e.message}"
      create_new_train
    end

    puts "Train added: #{trains.last.info}"
  end

  def create_station
    puts 'Put station name'
    name = gets.to_s
    stations << Station.new(name)
    puts "Station added: #{stations.last.name}"
    back_to_menu
  end

  def create_route
    if stations.empty? || stations.count < 2
      puts 'Please add more stations'
      back_to_menu
      return
    end

    puts "Select rout's stations"
    puts_stations_for_choice(stations)

    routes << Route.new(selected_station, selected_station)
    puts "Route added: #{routes.last.info}"

    back_to_menu
  end

  def back_to_menu
    puts 'Press enter to continue..'
    gets
  end

  def edit_route
    return unless valid_data?(routes)

    route = selected_rout

    puts '1 - Add station'
    puts '2 - Remove station'
    input = gets.to_i - 1

    case input
    when 1 then add_stantion_to_route(route)
    when 2 then remove_stantion_from_route(route)
    else 'Something wrong'
    end

    back_to_menu
  end

  def add_stantion_to_route(route)
    puts_stations_for_choice(stations)

    route.add_station(selected_station)
  end

  def remove_stantion_from_route(route)
    puts_stations_for_choice(route.stations)

    route.remove_station(selected_station)
  end

  def puts_stations_for_choice(station)
    station.each_with_index { |station, index| puts "#{index + 1} - station #{station.name}" }
  end

  def add_route_for_train
    if routes.empty? || trains.empty?
      puts 'Please add more trains or routes'
      return
    end

    train = selected_train
    train.add_route(selected_route)
    puts "#{train.info}"

    back_to_menu
  end

  def add_wagon_for_train
    return unless valid_data?(trains)

    train = selected_train
    wagons = create_wagons_by_type(train.type)
    train.add_wagons(wagons)
    puts "#{train.info}"

    back_to_menu
  end

  def remove_wagon_from_train
    return unless valid_data?(trains)

    puts "How many wagos need remove?"
    count = gets.to_i
    train = selected_train
    train.remove_wagons(count)
    puts "#{train.info}"

    back_to_menu
  end

  def create_wagons_by_type(type)
    puts 'How many wagons to add?'
    count = gets.to_i
    count.times.map { type == :passenger ? PassengerWagon.new : CargoWagon.new }
  end


  def move_train_forvard
    return unless valid_data?(trains)

    train = selected_train
    train.move_to_next_station
    puts "#{train.info}"

    back_to_menu
  end

  def move_train_back
    return unless valid_data?(trains)

    train = selected_train
    train.move_to_previous_station
    puts "#{train.info}"

    back_to_menu
  end

  def stations_info
    return unless valid_data?(stations)

    stations.each { |station| puts station.info }
    back_to_menu
  end

  def show_trains_on_the_station
    return unless valid_data?(stations)

    stations.each_with_index { |station, index| puts "#{index + 1} - #{station.info}" }
    selected_station.show_all_trains
    back_to_menu
  end

  def valid_data?(object)
    if object.empty?
      puts "Sorry, we don`t have enough data"
      false
    else
      true
    end
  end

  def selected_train
    puts "Select train"
    trains.each_with_index { |train, index| puts "#{index + 1} - train #{train.number}" }
    index = gets.to_i - 1
    trains[index]
  end

  def selected_route
    puts "Select number of route"
    routes.each_with_index { |route, index| puts "#{index + 1} - #{route.info}" }
    index = gets.to_i - 1
    routes[index]
  end

  def selected_station
    puts 'Select number of station'
    index = gets.to_i - 1
    stations[index]
  end
end
