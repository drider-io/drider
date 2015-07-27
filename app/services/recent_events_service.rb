class RecentEventsService
  def car_locations
    CarLocation.from(CarLocation.select('user_id, max(id) as location_id').group('user_id')).joins('JOIN car_locations ON id = location_id')
  end

  def car_searches
    CarSearch.order('id DESC').limit(10)
  end
end