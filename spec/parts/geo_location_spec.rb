require "rails_helper"

describe 'GeoLocation' do

  describe "#m" do
    it 'should return location of address' do
      geo = GeoLocation.new(address: 'Стороженка 12')
      expect(geo.m).to be_a RGeo::Geos::CAPIPointImpl
    end
  end

end