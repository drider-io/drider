locations = @car_session.car_locations.order('id DESC')

json.type "FeatureCollection"
json.features [@car_session] do |session|
  json.type "Feature"
  json.properties do
    json.markers locations do |location|
      json.title "#{link_to location.id, admin_car_location_path(location)} #{location.location_at.strftime("%H:%M")}"
      json.position do
        json.lat location.r.y
        json.lng location.r.x
      end
    end
  end
end

