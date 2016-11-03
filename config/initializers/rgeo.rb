RGeo::ActiveRecord::SpatialFactoryStore.instance.tap do |config|
  # By default, use the GEOS implementation for spatial columns.
  config.default = RGeo::Geographic.simple_mercator_factory(srid: 3857).projection_factory

  # But use a geographic implementation for point columns.
  # config.register(RGeo::Geographic.simple_mercator_factory(srid: 3785), geo_type: "point")
end
