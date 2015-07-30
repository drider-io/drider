class CarLocationsProcessor
  include Sidekiq::Worker

  def factory
    @factory ||= RGeo::Geographic.simple_mercator_factory(srid: 3785).projection_factory
  end


  def parser
    @parser ||= RGeo::WKRep::WKTParser.new(factory, support_ewkt: true, default_srid: 3785)
  end

  def initialize
    @log = ""
  end

  def min_route_HDdistance
    500
  end

  def min_route_distance
    500
  end



  def log(str)
    @log += str+"\n"
    logger.info str
  end

  def perform(session_id)
    session = CarSession.find(session_id)
    last_location_time = session.car_locations.maximum(:created_at)
    unless session.processed && last_location_time + 14.minutes < Time.now
      process_session(session)
      ActionMailer::Base.mail(
             from: '700@2rba.com',
             to: 'reports@mx.2rba.com',
             body: @log,
             content_type: "text/plain",
             subject: 'Drider route processing'
      ).deliver_now
    end
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
    route_result = ActiveRecord::Base.connection.exec_query(sql).to_a.try(:first)

    distance = route_result.try(:[], 'distance')
    if distance
      if distance.to_i > min_route_distance
        same_route = select_same_routes(route_result['route'], route_result['start'], route_result['finish'], session.user.id)
        # if same_route
        #    "closest route(#{same_route['id']}), distance #{same_route['distance']}"
        # else
        #    "no routes found for session #{session.id} "
        # end
        if same_route && same_route['distance'].to_i < min_route_HDdistance
          log "consider session(#{session.id}) route(#{same_route['id']}), distance: #{distance}, HDdistance #{same_route['distance']} as a same route, user: #{session.user.name}"
          session.update!(processed: true, car_route_id: same_route['id'])
        else
          max_min = session.car_locations.select('max(created_at) as max, min(created_at) as min').to_a.first
          start_address = GeoLocation.new(location: parser.parse(route_result['start']) ).address
          stop_address = GeoLocation.new(location: parser.parse(route_result['finish']) ).address
          sql =<<SQL
INSERT INTO car_routes (user_id, created_at, updated_at, route, started_at, finished_at, from_m, to_m, from_address, to_address) VALUES( $1, $2, $2, ST_GeomFromEWKT($3), $4, $5, ST_GeomFromEWKT($6), ST_GeomFromEWKT($7), $8, $9 ) RETURNING id::text
SQL
          ActiveRecord::Base.transaction do
          result = ActiveRecord::Base.connection.exec_query(sql,'SQL', [
                                                                  [nil, session.user.id],
                                                                  [nil, Time.now],
                                                                  [nil, route_result['route']],
                                                                  [nil, max_min['min']],
                                                                  [nil, max_min['max']],
                                                                  [nil, route_result['start']],
                                                                  [nil, route_result['finish']],
                                                                  [nil, start_address],
                                                                  [nil, stop_address]
                                                               ]
          ).first
          session.update!(processed: true, car_route_id: result['id'])
          session.user.update(ever_drive: true) unless session.user.ever_drive
          # p result
          same_route_desc = ''
          same_route_desc = " HDdistance(#{same_route['distance']}), " if same_route
          log "created route( #{result['id']} ) from session( #{session.id} ) distance #{distance},#{same_route_desc} user: #{session.user.name}"
          end
        end
      else
        log "session #{session.id} have distance #{distance} less then #{min_route_HDdistance}, skipping, user: #{session.user.name}"
        session.update!(processed: true)
      end

    else
      log "session #{session.id} does not have locations, skipping, user: #{session.user.name}"
      session.update!(processed: true)
    end
  end

  def process
    log "car_location -> car_routes started"
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
  ST_DWithin(ST_PointN(route,1), ST_GeomFromEWKT( $2 ), 500 ) AND
  ST_DWithin(ST_PointN(route, ST_NPoints(route)), ST_GeomFromEWKT( $3 ), 500 )
) as rr ORDER BY distance ASC

SQL
    # printf sql
    # print route
    ActiveRecord::Base.connection.exec_query(sql,'SQL', [[nil, route], [nil,start], [nil,finish], [nil,user_id]] ).first
  end

end