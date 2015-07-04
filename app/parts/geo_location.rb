class GeoLocation
  def initialize(address:nil)
    @address = address
  end

  def m
    unless @m
      geo = Geocoder.search("Україна, Львів, #{@address}").try(:first)
      @m = to_m(geo.coordinates[0], geo.coordinates[1])
    end
    @m
  end


  def to_m(lat, long)
    RGeo::Geographic.simple_mercator_factory(srid: 3857).point(long, lat).projection
  end
end