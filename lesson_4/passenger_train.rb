class PassengerTrain < Train
  def initialize(wagons_count)
    wagons = wagons_count.times.map { PassengerWagon.new }
    super(:passenger, wagons)
  end
end
