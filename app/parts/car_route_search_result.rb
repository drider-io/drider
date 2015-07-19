class CarRouteSearchResult
  attr_reader :route
  def initialize(route)
    @route = route
  end

  def pickup_address
    GeoLocation.new(location: route['pickup_point']).address
  end

  def drop_address
    GeoLocation.new(location: route['drop_point']).address
  end

  def id
    route['id']
  end


  def pickup_location
    GeoLocation.new(location: route['pickup_point']).g
  end

  def drop_location
    GeoLocation.new(location: route['pickup_point']).g
  end

  def shared_route
    GeoLocation.new.to_g(route['sub_route'])
  end

  def pickup_time
    '12:00'
  end

  def created_at
    route['created_at']
  end

  def driver
    @driver ||= User.find(route['user_id'])
  end
end
