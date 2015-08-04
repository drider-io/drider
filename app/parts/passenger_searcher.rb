class PassengerSearcher
  def initialize(routes:)
    @routes = routes
  end

  def search

inner_query = CarRoute.select(%q{
car_routes.*,
car_searches.id as car_search_id,
car_searches.user_id as passenger_id,
car_searches.time as passenger_time,
car_searches.from_m as passenger_from_m,
car_searches.to_m as passenger_to_m,
ST_ClosestPoint(route, car_searches.from_m) as pickup_location,
ST_ClosestPoint(route, car_searches.to_m) as drop_location,
ST_LineLocatePoint(route, car_searches.from_m) as pickup_float,
ST_LineLocatePoint(route, car_searches.to_m) as drop_float
}).joins(%q{
JOIN car_searches ON
ST_DWithin(car_routes.route, car_searches.from_m, 500 ) AND
ST_DWithin(car_routes.route, car_searches.to_m, 500 )
         })
.where('car_routes.id IN (?)', @routes.map(&:id))
.where('car_searches.user_id IS NOT NULL')

results = CarRoute.select('*, ST_LineSubstring(route, pickup_float, drop_float) as sub_route')
    .from(inner_query)
    .where('drop_float > pickup_float')

    group(results)
  end


  def group(results)
    grouped_results = results.map{ |r| PassengerSearchResult.new(r) }.group_by { |r| r.car_search_id }.values
  end
end