class CarLocationsProcessor
  include Sidekiq::Worker

  def initialize()

  end

  def min_route_distance
    500
  end

  def perform(session_id)
    session = CarSession.find(session_id)
    last_location_time = session.car_locations.maximum(:created_at)
    process_session(session) unless session.processed && last_location_time + 14.minutes < Time.now
  end

  def process_session(session)
    sql_route = session.car_locations.select("ST_Simplify(ST_MakeLine(m ORDER BY id),10) as route").to_sql
    sql = <<SQL
SELECT
ST_MaxDistance(rr.route, rr.route) as distance,
ST_AsEWKT(ST_PointN(rr.route, 1)) as start,
ST_AsEWKT(ST_PointN(rr.route, ST_NPoints(rr.route))) as finish,
ST_AsEWKT(rr.route) as route
FROM
(#{sql_route}) as rr
SQL
    result = ActiveRecord::Base.connection.exec_query(sql).to_a
    distance = result.try(:first).try(:[], 'distance')
    if distance
      if distance.to_i > min_route_distance
        same_route = select_same_routes(result.first['route'], result.first['start'], result.first['finish'], session.user.id)
        if same_route
          logger.info "closest route(#{same_route['id']}), distance #{same_route['distance']}"
        else
          logger.info "no routes found for session #{session.id}"
        end
        if same_route && same_route['distance'].to_i < min_route_distance
          logger.info "consider route(#{same_route['id']}), distance #{same_route['distance']} as a same route"
          session.update!(processed: true, car_route_id: same_route['id'])
        else
          max_min = session.car_locations.select('max(created_at) as max, min(created_at) as min').to_a.first
          sql =<<SQL
INSERT INTO car_routes (user_id, created_at, updated_at, route, started_at, finished_at) VALUES( $1, $2, $2, ST_GeomFromEWKT($3), $4, $5) RETURNING id::text
SQL
          ActiveRecord::Base.transaction do
          result = ActiveRecord::Base.connection.exec_query(sql,'SQL', [[nil, session.user.id],
                                                                        [nil, Time.now],
                                                                        [nil, result.first['route']],
                                                                        [nil, max_min['min']],
                                                                        [nil, max_min['max']]]
          ).first
          session.update!(processed: true, car_route_id: result['id'])
          # p result
          end

        end
      else
        logger.info "session #{session.id} have distance #{distance} less then #{min_route_distance}, skipping"
        session.update!(processed: true)
      end

    else
      logger.info "session #{session.id} does not have locations, skipping"
      session.update!(processed: true)
    end
  end

  def process
    logger.info "car_location -> car_routes started"
    CarSession.where(processed: false).find_each do |session|
      process_session(session)
    end
  end

  private

  def select_same_routes(route, start, finish, user_id)
sql = <<SQL
SELECT id, distance from (
  SELECT car_routes.id, ST_HausdorffDistance(route, ST_GeomFromEWKT( $1 ) ) as distance FROM car_routes WHERE
  user_id = $4 AND
  ST_DWithin(ST_PointN(route,1), ST_GeomFromEWKT( $2 ), 200 ) AND
  ST_DWithin(ST_PointN(route, ST_NPoints(route)), ST_GeomFromEWKT( $3 ), 200 )
) as rr WHERE distance >=0 ORDER BY distance ASC

SQL
    # printf sql
    # print route
    ActiveRecord::Base.connection.exec_query(sql,'SQL', [[nil, route], [nil,start], [nil,finish], [nil,user_id]] ).first
  end

end