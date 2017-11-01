class CarRoute < ActiveRecord::Base
  belongs_to :user
  has_many :car_route_stats
  has_many :car_sessions, dependent: :nullify
  has_many :details_logs, as: :parent, dependent: :destroy

  scope :without_user, ->(user) do
    where.not(user: user)
  end

  scope :actual , -> do
    where.not(deleted_at: nil)
  end

  def self.select_with_args(sql, args)
    query = sanitize_sql_array([sql, args].flatten)
    select(query)
  end

  def self.active_stats
    connection.exec_query("SELECT count(distinct user_id) as users_count, count(id) as routes_count FROM car_routes WHERE updated_at >= (CURRENT_DATE - INTERVAL '1 week')").first
  end
end
