class RecentEventsSerializer
  def initialize(source)
    @source = source
  end

  def as_json(options = nil)
      color_generator = ColorGenerator.new saturation: 0.3, lightness: 0.25, hue: 1
      {
          type: 'FeatureCollection',
          features: car_search_features + car_features
      }
  end

  def car_features
    @source.car_locations.map { |location|
                {
                    type: 'Feature',
                    properties: {
                        id: location.id,
                        type: 'car',
                        marker:{
                          position:{
                                      lat: location.r.y,
                                      lng: location.r.x
                                   },
                          icon: ActionController::Base.helpers.image_path("icons/favicon.png"),
                        }
                    },
                }
    }
  end

  def car_search_features
    @source.car_searches.map { |search|
      geo = GeoLocation.new.to_g(search.to_m)
      {
        type: 'Feature',
        properties: {
          id: search.id,
          type: 'search',
          marker:{
            title: "До #{search.to_title}",
            position: {
                lat: geo.y,
                lng: geo.x
             },
          }
        },
      }
    }
  end
end