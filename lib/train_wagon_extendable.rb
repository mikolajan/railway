module TrainWagonExtendable
  TYPES = %i(cargo passenger)

  attr_accessor :created_by
  attr_reader :number, :type, :errors

  def cargo?
    @type == TYPES[0]
  end

  def passenger?
    @type == TYPES[1]
  end
end
