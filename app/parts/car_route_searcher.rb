class CarRouteSearcher
  def search(car_search)
    within_sql =<<SQL
  ST_DWithin(route, ?, 500 ) AND
  ST_DWithin(route, ?, 500 )
SQL
    users = CarRoute.select('DISTINCT user_id').where(within_sql, car_search.from_m, car_search.to_m )

    select = <<SQL
*,
ST_ClosestPoint(route, ?) as start,
ST_ClosestPoint(route, ?) as finish,
ST_LineLocatePoint()
SQL
    p = CarRoute
            .select_with_args(select, [car_search.from_m, car_search.to_m])
            .where(user_id: users.map{|u| u.user_id})
            .where(within_sql, car_search.from_m, car_search.to_m )



    # p = CarRoute.select_with_args("1, ? , ?", [2,3])
    # CarRoute.where(driver_id: users)




    p routes
    routes
  end

end