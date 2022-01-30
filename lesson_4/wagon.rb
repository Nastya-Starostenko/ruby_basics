class Wagon

  attr_reader :type
  attr_accessor :train, :number, :info

  def initialize(type)
    @type = type
  end
end
