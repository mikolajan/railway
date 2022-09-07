module TrainWagonExtendable
  TYPES = %i(cargo passenger)

  attr_accessor :created_by
  attr_reader :number, :type

  def find(number)
    instances.find { |item| item.number == number }
  end
end
