class CarRouteSerializer
  def initialize(route)
     @route = route
   end

   def as_json(options = nil)
     color_generator = ColorGenerator.new saturation: 0.3, lightness: 0.25, hue: 1
     from_g = GeoLocation.new.to_g(@route.from_m)
     to_g = GeoLocation.new.to_g(@route.to_m)
     route_route = GeoLocation.new.to_g(@route.route)
     {
         type: 'FeatureCollection',
         features: [@route].map { |e|
           {
               type: 'Feature',
               properties: {
                   id: e.id,
                   color: "##{color_generator.create_hex}",
                   markers: [
                       {
                           title: 'Початок',
                           position: {
                             lat: from_g.y,
                             lng: from_g.x
                           },
                       },
                       {
                           title: 'Кінець',
                           position: {
                             lat: to_g.y,
                             lng: to_g.x
                           },
                           icon: ActionController::Base.helpers.image_path("icons/finish.png"),
                       },

                   ]
               },
               geometry: RGeo::GeoJSON.encode(route_route)
           }
         }
     }
   end
end