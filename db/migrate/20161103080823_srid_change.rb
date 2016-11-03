class SridChange < ActiveRecord::Migration
  def up
    execute('ALTER TABLE car_locations ALTER COLUMN m TYPE geometry(Point, 3857) USING ST_SetSRID(m, 3857);')

    execute('ALTER TABLE car_routes ALTER COLUMN from_m TYPE geometry(Point, 3857) USING ST_SetSRID(from_m, 3857);')
    execute('ALTER TABLE car_routes ALTER COLUMN to_m TYPE geometry(Point, 3857) USING ST_SetSRID(to_m, 3857);')
    execute('ALTER TABLE car_routes ALTER COLUMN route TYPE geometry(LineString, 3857) USING ST_SetSRID(route, 3857);')

    execute('ALTER TABLE car_searches ALTER COLUMN from_m TYPE geometry(Point, 3857) USING ST_SetSRID(from_m, 3857);')
    execute('ALTER TABLE car_searches ALTER COLUMN to_m TYPE geometry(Point, 3857) USING ST_SetSRID(to_m, 3857);')
  end
end
