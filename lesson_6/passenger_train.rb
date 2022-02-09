class PassengerTrain < Train
  def initialize(wagons, number)
    super(:passenger, wagons, number)
  end
end
