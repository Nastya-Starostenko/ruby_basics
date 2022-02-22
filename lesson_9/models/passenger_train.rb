# frozen_string_literal: true

class PassengerTrain < Train
  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT
  validate :type, :presence

  def initialize(**args)
    super(:passenger, **args)
  end
end
