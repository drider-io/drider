class CarRequestCreator
  def initialize(passenger)
    @passenger = passenger
  end

  def create(drivers_ids)
    drivers_ids.each do |driver_id|
      CarRequest.create(driver_id: driver_id,
                        passenger: @passenger,
                        status: :sent
      )
    end
  end
end
