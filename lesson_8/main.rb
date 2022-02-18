# frozen_string_literal: true

require_relative 'models/route'
require_relative 'models/train'
require_relative 'models/passenger_train'
require_relative 'models/cargo_train'
require_relative 'models/station'
require_relative 'models/wagon'
require_relative 'models/cargo_wagon'
require_relative 'models/passenger_wagon'
require_relative 'modules/manufacturer'
require_relative 'modules/instance_counter'
require_relative 'stations_action'
require_relative 'routes_action'
require_relative 'trains_action'

class Main
  include StationsAction
  include RoutesAction
  include TrainsAction

  attr_accessor :stations, :routes, :wagons, :trains

  def initialize
    @stations = Station.all
    @routes = Route.all
    @wagons = Wagon.all
    @trains = Train.all
    set_values
    start
  end

  def set_values
    set_stations
    set_routes
    3.times do

      cargo_wagons, pass_wagons = [],[]
      2.times { cargo_wagons << CargoWagon.new(50) }
      CargoTrain.new(wagons: cargo_wagons, route: routes.sample)
      2.times { pass_wagons << PassengerWagon.new(50) }
      PassengerTrain.new(wagons: pass_wagons, route: routes.sample)
    end
  rescue StandardError => e
    puts "Exeption: #{e.message}"
  end

  def start
    loop do
      menu[:main].each_with_index { |action, index| puts "Put #{index + 1} for #{action}" }
      puts 'Put 0 or any symbol for exit'

      input = gets.chomp.to_i
      break if input.zero?

      main_menu(input)
    end
  end

  def basic_menu(text, actions)
    loop do
      text.each_with_index { |action, index| puts "Put #{index + 1} for #{action}" }
      puts 'Put 0 or any symbol for exit'

      input = gets.chomp.to_i
      break if input.zero?

      send actions, input
      # puts 'Error: menu has an invalid value'
    end
  end

  def menu
    { main: ['Action with stations', 'Action with routes', 'Action with trains', 'Action with wagons'],
      stations: ['create new station', 'show list of station', 'show trains on the station',
                 'show all wagons on stations'],
      routes: ['create new route', 'edit route'],
      trains: ['create new train', 'add route for train', 'add wagon to train', 'remove wagon from train',
               'move train forward', 'move train back'],
      wagons: ['show all wagons on trains','take place or volume in wagon'] }
  end

  def main_menu(input)
    case input
    when 1 then basic_menu(menu[:stations], :stations_actions)
    when 2 then basic_menu(menu[:routes], :routes_actions)
    when 3 then basic_menu(menu[:trains], :trains_actions)
    when 4 then basic_menu(menu[:wagons], :wagons_actions)
    else 'Error: menu has an invalid value'
    end
  end

  def wagons_actions(input)
    case input
    when 1 then show_all_wagons_on_trains
    when 2 then take_place_in_wagon
    else 'Error: menu has an invalid value'
    end
  end

  private

  def take_place_in_wagon
    puts 'Hello'
    train = selected_train
    show_all_wagons_on_trains([train])

    puts 'Select wagon'
    train.wagons.each_with_index { |wagon, index| puts "#{index + 1} - wagon #{wagon.number}" }
    index = gets.to_i - 1
    wagon = train.wagons[index]
    wagon.type == :cargo ? take_volume_in_wagon(wagon) : wagon.take_place
    puts "Now on the wagon free places: #{wagon.free_places}, occupied places: #{wagon.occupied_places}"

    back_to_menu
  end

  def take_volume_in_wagon(wagon)
    puts 'How much volume you want to load?'
    volume = gets.chomp.to_i

    wagon.take_place(volume)
  end

  def create_wagons_by_type(type)
    puts 'How many wagons to add?'
    count = gets.to_i
    puts type == :cargo ? 'Put volume for wagons' : 'Put places count for each wagons'
    volume_or_places = gets.to_i
    count.times.map { type == :cargo ? CargoWagon.new(volume_or_places) : PassengerWagon.new(volume_or_places) }
    back_to_menu
  end

  def back_to_menu
    puts 'Press enter to continue..'
    gets
  end
end
