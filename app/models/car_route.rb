class CarRoute < ActiveRecord::Base
  belongs_to :user
  has_many :car_route_stats
  def self.select_with_args(sql, args)
    query = sanitize_sql_array([sql, args].flatten)
    select(query)
  end
end
