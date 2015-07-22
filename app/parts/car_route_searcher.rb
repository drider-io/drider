class CarRouteSearcher
  def search(car_search)
#
#     s1 = CarRoute.from(CarRoute.all)
#     p  = s1.project(1).to_sql
#
#     p p
#     return
#     within_sql =<<SQL
# SQL
#     users = CarRoute.select('DISTINCT user_id').where(within_sql, car_search.from_m, car_search.to_m )
#
#     select =


    inner_query = CarRoute
            .select_with_args('
*,
ST_ClosestPoint(route, ?) as pickup_location,
ST_ClosestPoint(route, ?) as drop_location,
ST_LineLocatePoint(route, ?) as pickup_float,
ST_LineLocatePoint(route, ?) as drop_float
', [car_search.from_m, car_search.to_m, car_search.from_m, car_search.to_m])
            .where('
ST_DWithin(route, ?, 500 ) AND
ST_DWithin(route, ?, 500 )
', car_search.from_m, car_search.to_m )

    routes = CarRoute.select('*, ST_LineSubstring(route, pickup_float, drop_float) as sub_route')
        .from(inner_query)
        .where('drop_float > pickup_float')
        #TODO .where('updated_at >= ?', Time.now - 10.days)
    p routes
    # r = Geocoder.search([29.951,-90.081])
    grouped_routes = routes.group_by { |route| route.user_id }
    # uniq_user_routes = grouped_routes.values{|rts| rts.max{|rr| rr.id }}.flatten
    grouped_routes.map do |k,rts|
      times = rts.map{|rr| rr.started_at.to_formatted_s(:time) }.join(', ')
      last_route = rts.max{|rr| rr.id }
      CarRouteSearchResult.new(last_route, times)
    end
  end

end