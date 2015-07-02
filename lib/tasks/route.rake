namespace :route do
  desc "Create/Update CarRoutes from CarLocations"
  task update: :environment do
    CarSession.where(processed: false).find_each do |session|
      sql = session.car_locations.select("#{session.user_id}, '#{Time.now.to_s}', '#{Time.now.to_s}', ST_Simplify(ST_MakeLine(m),10) as route").to_sql
      p sql
      insert_sql = "INSERT INTO car_routes (user_id, created_at, updated_at, route) (#{sql}) RETURNING id::text"
      p insert_sql
      ActiveRecord::Base.transaction do
      result = CarRoute.connection.exec_query(insert_sql).first
      session.update!(processed: true)
      p result
      end
      break
    end
  end

end
