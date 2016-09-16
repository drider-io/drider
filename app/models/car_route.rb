class CarRoute < ActiveRecord::Base
  belongs_to :user
  has_many :car_route_stats
  has_many :car_sessions

  def self.select_with_args(sql, args)
    query = sanitize_sql_array([sql, args].flatten)
    select(query)
  end

  def self.active_stats
    connection.exec_query("SELECT count(distinct user_id) as users_count, count(id) as routes_count FROM car_routes WHERE updated_at >= (CURRENT_DATE - INTERVAL '1 week')").first
  end
end
