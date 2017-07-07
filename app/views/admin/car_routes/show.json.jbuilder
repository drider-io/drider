serialized_route = RGeo::GeoJSON.encode(GeoLocation.new.to_g(@car_route.route))
session = @car_route.car_sessions.order('id DESC').first
locations = session.car_locations.order('id DESC')

json.type "FeatureCollection"
json.features [@car_routes] do |route|
  json.type "Feature"
  json.properties do
    json.markers locations do |location|
      json.title "#{link_to location.id, admin_car_location_path(location)} #{location.location_at.try(:strftime, "%H:%M")}"
      json.position do
        json.lat location.r.y
        json.lng location.r.x
      end
    end
  end
  json.geometry serialized_route
end

