class PassengerSearchResult
  def initialize(result)
    @result = result
  end

  def id
    @result['id']
  end

  def car_search_id
    @result['car_search_id']
  end

  def from_address
    @result['from_address']
  end

  def to_address
    @result['to_address']
  end

  def passenger
    @passenger ||= User.find(@result['passenger_id'])
  end

  def passenger_time
    @result['passenger_time'].to_formatted_s(:time)
  end

  def pickup_address
    GeoLocation.new(location: @result['pickup_location']).address
  end

  def drop_address
    GeoLocation.new(location: @result['drop_location']).address
  end

  def pickup_location
    GeoLocation.new(location: @result['pickup_location']).g
  end

  def drop_location
    GeoLocation.new(location: @result['drop_location']).g
  end

end