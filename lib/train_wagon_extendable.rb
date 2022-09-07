module TrainWagonExtendable
  TYPES = %i(cargo passenger)

  attr_accessor :created_by
  attr_reader :number, :type
end
