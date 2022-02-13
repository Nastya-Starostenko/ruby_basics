class PassengerTrain < Train
  def initialize(wagons, number, route = nil)
    super(:passenger, wagons, number, route)
  end
end
