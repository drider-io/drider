class CarRouteFetcher
  def fetch(car_request)
    inner_query = CarRoute
            .select_with_args('
*,
ST_LineLocatePoint(route, ?) as pickup_float,
ST_LineLocatePoint(route, ?) as drop_float
', [car_request.pickup_location, car_request.drop_location])
            .where(id: car_request.car_route_id)

    route = CarRoute.select('*, ST_LineSubstring(route, pickup_float, drop_float) as sub_route')
        .from(inner_query)
      .to_a.first.attributes.to_hash
    route['pickup_location'] = car_request.pickup_location
    route['drop_location'] = car_request.drop_location
    CarRouteSearchResult.new(route, "")
  end

end