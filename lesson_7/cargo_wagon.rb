class CargoWagon < Wagon

# Добавить атрибут общего объема (задается при создании вагона)
# Добавить метод, которые "занимает объем" в вагоне (объем указывается в качестве параметра метода)
# Добавить метод, который возвращает занятый объем
# Добавить метод, который возвращает оставшийся (доступный) объем

attr_reader :free_volume, :occupied_volume

def initialize(volume)
  @volume = volume
  @free_volume = volume
  @occupied_volume = 0
  super(:cargo)
end

def load(volume)
  raise "Wagon doesn`t have enough places" if free_volume < volume

  self.occupied_volume += volume
  self.free_volume -= volume
end

private

attr_accessor :volume
attr_writer :free_volume, :occupied_volume

end
