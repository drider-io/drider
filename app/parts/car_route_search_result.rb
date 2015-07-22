class CarRouteSearchResult
  attr_reader :route, :pickup_time
  def initialize(route, pickup_time)
    @route = route
    @pickup_time = pickup_time
  end

  def pickup_address
    GeoLocation.new(location: route['pickup_location']).address
  end

  def drop_address
    GeoLocation.new(location: route['drop_location']).address
  end

  def id
    route['id']
  end


  def pickup_location
    GeoLocation.new(location: route['pickup_location']).g
  end

  def drop_location
    GeoLocation.new(location: route['drop_location']).g
  end

  def shared_route
    GeoLocation.new.to_g(route['sub_route'])
  end

  def started_at
    route['started_at']
  end

  def driver
    @driver ||= User.find(route['user_id'])
  end
end
