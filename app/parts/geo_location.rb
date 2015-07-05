class GeoLocation
  def initialize(address:nil, location:nil)
    @address = address
    @location = location
  end

  def m
    unless @m
      geo = Geocoder.search("Україна, Львів, #{@address}").try(:first)
      @m = to_m(geo.coordinates[0], geo.coordinates[1])
    end
    @m
  end

  def address
    unless @address
      r = RGeo::Feature.cast(@location, :factory => RGeo::Geographic.spherical_factory(srid: 4326), :project => true)
      geo = Geocoder.search([r.y, r.x]).try(:first)
      @address = geo.data['GeoObject']['name'] if geo
    end
    @address
  end


  def to_m(lat, long)
    RGeo::Geographic.simple_mercator_factory(srid: 3857).point(long, lat).projection
  end
end