class CarSearchResultSerializer
  def initialize(search_result)
    @search_result = search_result
  end

  def as_json(options = nil)
    color_generator = ColorGenerator.new saturation: 0.3, lightness: 0.25, hue: 1
    {
        type: 'FeatureCollection',
        features: @search_result.map { |e|
          {
              type: 'Feature',
              properties: {
                  id: e.id,
                  color: "##{color_generator.create_hex}",
                  markers: [
                      {
                          title: 'Початок',
                          position: {
                            lat: e.pickup_location.y,
                            lng: e.pickup_location.x
                          },
                      },
                      {
                          title: 'Призначення',
                          position: {
                            lat: e.drop_location.y,
                            lng: e.drop_location.x
                          },
                          icon: ActionController::Base.helpers.image_path("icons/finish.png"),
                      },

                  ]
              },
              geometry: RGeo::GeoJSON.encode(e.shared_route)
          }
        }
    }
  end
end