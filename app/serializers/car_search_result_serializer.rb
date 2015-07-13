class CarSearchResultSerializer
  def initialize(search_result)
    @search_result = search_result
  end

  def as_json(options = nil)
    {
        type: 'FeatureCollection',
        features: @search_result.map { |e|
          {
              type: 'Feature',
              properties: {},
              geometry: RGeo::GeoJSON.encode(e.shared_route)
          }
        }
    }
  end
end