require "rails_helper"

describe GeoLocation do

  describe "#m" do
    it 'should return location of address' do
      VCR.use_cassette('geocoder/address_to_location') do
        geo = GeoLocation.new(address: 'Стороженка 12')
        expect(geo.m).to be_a RGeo::Geos::CAPIPointImpl
        expect(geo.m.srid).to eql(3785)
        expect(geo.m.x).to eql(2671865.037176251)
        expect(geo.m.y).to eql(6418956.127979133)
      end
    end
  end

  describe "#address" do
    it 'should return address for location' do
      VCR.use_cassette('geocoder/location_to_address') do
        geo = GeoLocation.new(location: RGeo::Geographic.simple_mercator_factory(srid: 3785).projection_factory.point(2671865.03717625, 6418956.12797913))
        expect(geo.address).to eql("вулиця Стороженка, 12")
      end
    end
  end

end