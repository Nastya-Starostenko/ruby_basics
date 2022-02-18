# frozen_string_literal: true

class PassengerTrain < Train
  def initialize(**args)
    super(:passenger, **args)
  end
end
