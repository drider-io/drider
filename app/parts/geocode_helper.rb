class GeocodeHelper
  def geocode_by_name(name)
    geo = Geocoder.search("Україна, Львів, #{name}").try(:first)
    {
        address: geo.data['GeoObject']['name'],
        location: geo.coordinates
    } if geo
  end
end