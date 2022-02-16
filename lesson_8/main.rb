# frozen_string_literal: true

require_relative 'route'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'station'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'
require_relative 'manufacturer'
require_relative 'instance_counter'

class Main
  attr_accessor :stations, :routes, :wagons, :trains

  def initialize
    @stations = []
    @routes = []
    @wagons = []
    @trains = []
    set_values
    start
  end

  def set_values
    %w[Odessa Kharkiv Kiev Moscow Lviv].each do |city|
      stations << Station.new(city)
    end

    3.times { routes << Route.new(stations.sample, stations.sample) }

    6.times { wagons << CargoWagon.new(50) }
    6.times { wagons << PassengerWagon.new(5) }

    cargo_wagons = wagons.select { |w| w.type == :cargo }.each_slice(2).map(&:itself)
    pass_wagons = wagons.select { |w| w.type == :passenger }.each_slice(2).map(&:itself)

    3.times { |i| trains << CargoTrain.new(cargo_wagons[i], train_number, routes.sample) }
    3.times { |i| trains << PassengerTrain.new(pass_wagons[i], train_number, routes.sample) }
  rescue StandardError => e
    puts "Exeption: #{e.message}"
  end

  def start
    loop do
      menu.each_with_index { |action, index| puts "Put #{index + 1} for #{action}" }
      puts 'Put 0 for exit'

      input = gets.to_i
      break if input.zero?

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
      when 12 then show_all_trains_on_stations
      when 13 then show_all_wagons_on_trains
      when 14 then take_place_or_volume_in_wagon
      else
        'Error: menu has an invalid value'
      end
    end
  end

  private

  def take_place_or_volume_in_wagon
    train = selected_train
    show_all_wagons_on_trains([train])

    puts 'Select wagon'
    filtered_wagons = wagons.filter { |wagon| wagon.train == train }
    filtered_wagons.each_with_index { |wagon, index| puts "#{index + 1} - wagon #{wagon.number}" }
    index = gets.to_i - 1
    wagon = filtered_wagons[index]
    wagon.type == :cargo ? take_volume_in_wagon(wagon) : wagon.take_place
    puts "Now on the wagon free places: #{wagon.free_places}, occupied places: #{wagon.occupied_places}"
  end

  def take_volume_in_wagon(wagon)
    puts 'How much volume you want to load?'
    volume = gets.chomp.to_i

    wagon.take_place(volume)
  end

  def show_all_trains_on_stations(need_stations = [])
    stations_for_info = need_stations.empty? ? stations : need_stations
    block = ->(x) { puts "Train number: #{x.number}, type: #{x.type}, wagons count: #{x.wagons.count}" }
    stations_for_info.each { |station| station.action_with_train(&block) }
  end

  def show_all_wagons_on_trains(need_trains = [])
    trains_for_info = need_trains.empty? ? trains : need_trains
    block = lambda do |x|
      info = "free places: #{x.free_places}, occupied places #{x.occupied_places}"
      puts "Wagon number: #{x.number}, type: #{x.type},  #{info}"
    end
    trains_for_info.each do |train|
      puts "Train: #{train.number}"
      train.action_with_wagons(&block)
    end
  end

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
     'show trains on the station',
     'show all wagons on stations',
     'show all wagons on trains',
     'take place or volume in wagon']
  end

  def create_new_train
    puts '1 - create cargo train'
    puts '2 - create passanger train'
    puts '0 - back to previous menu'

    input = gets.to_i
    return if input.zero?

    case input
    when 1 then create_train(:passenger)
    when 2 then create_train(:cargo)
    else
      'Error: menu has an invalid value'
    end

    back_to_menu
  end

  def create_train(type)
    puts 'Put train name or put 0 for random value'
    number = gets.to_i
    begin
      wagons = create_wagons_by_type(type)
      if trains << type == :cargo
        CargoTrain.new(wagons,
                       train_number(number))
      else
        PassengerTrain.new(wagons, train_number(number))
      end
      puts "Train added: #{trains.last.info}"
    rescue StandardError => e
      puts "Exeption: #{e.message}"
      create_new_train
    end
  end

  def get_rand_train_number
    "#{rand(36**3).to_s(36)}-#{rand(10..99)}"
  end

  def train_number(number = nil)
    number.nil? ? get_rand_train_number : number
  end

  def create_wagons_by_type(type)
    puts 'How many wagons to add?'
    count = gets.to_i
    puts type == :cargo ? 'Put volume for wagons' : 'Put places count for each wagons'
    volume_or_places = gets.to_i
    count.times.map { type == :passenger ? PassengerWagon.new(volume_or_places) : CargoWagon.new(volume_or_places) }
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
    puts train.info.to_s

    back_to_menu
  end

  def add_wagon_for_train
    return unless valid_data?(trains)

    train = selected_train
    wagons = create_wagons_by_type(train.type)
    train.add_wagons(wagons)
    puts train.info.to_s

    back_to_menu
  end

  def remove_wagon_from_train
    return unless valid_data?(trains)

    puts 'How many wagos need remove?'
    count = gets.to_i
    train = selected_train
    train.remove_wagons(count)
    puts train.info.to_s

    back_to_menu
  end

  def move_train_forvard
    return unless valid_data?(trains)

    train = selected_train
    train.move_to_next_station
    puts train.info.to_s

    back_to_menu
  end

  def move_train_back
    return unless valid_data?(trains)

    train = selected_train
    train.move_to_previous_station
    puts train.info.to_s

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
      puts 'Sorry, we don`t have enough data'
      false
    else
      true
    end
  end

  def selected_train
    puts 'Select train'
    trains.each_with_index do |train, index|
      puts "#{index + 1} - train #{train.number}, #{train.type}, route: #{train.route.info}"
    end
    index = gets.to_i - 1
    trains[index]
  end

  def selected_route
    puts 'Select number of route'
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
