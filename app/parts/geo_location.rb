class GeoLocation
  def initialize(address:nil, location:nil)
    @address = address
    @location = location
  end

  def m
    unless @location
      geo = Geocoder.search("Україна, Львів, #{@address}").try(:first)
      @location = to_m(geo.coordinates[0], geo.coordinates[1])
    end
    @location
  end

  def g
    unless @g
      @g = to_g(m)
    end
    @g
  end

  def address
    unless @address
      r = RGeo::Feature.cast(@location, :factory => RGeo::Geographic.spherical_factory(srid: 4326), :project => true)
      geo = Geocoder.search([r.y, r.x]).try(:first)
      @address = geo.data['GeoObject']['name'] if geo
    end
    @address
  end


  def to_m(lat, lng)
    RGeo::Geographic.simple_mercator_factory(srid: 3857).point(lng, lat).projection
  end

  def to_g(m)
    RGeo::Feature.cast(m, :factory => RGeo::Geographic.spherical_factory(srid: 4326), :project => true)
  end

  def str_to_m(str)
    match = str.match /^(\d+\.{,1}\d+)\s*\,{,1}\s*(\d+\.{,1}\d+)$/
    if match
      to_m(match[1], match[2])
    else
      nil
    end
  end

  def address_double_code
    self.class.new(location: m).address
  end
end
