class Station
  attr_accessor :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def add_train(train)
    return if trains.include? train

    trains << train
  end

  def trains_by_type
    types_of_train.each do |train_type|
      puts "#{train_type} trains: #{train_cont_by_type(train_type)}"
    end
  end

  def show_all_trains
    trains.each {|train| puts "Train #{train.number}, type: #{train.type}, car count: #{train.car_count}"}
  end

  def train_departure(train)
    return if trains.empty?

    trains.delete(train)
  end

  def train_cont_by_type(type)
    trains.select {|train| train.type == type }.count
  end

  def types_of_train
    trains.map {|train| train.type}.uniq
  end
end
