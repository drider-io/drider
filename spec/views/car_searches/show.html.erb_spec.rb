require 'rails_helper'

RSpec.describe "car_searches/show", type: :view do
  before(:each) do
    @car_search = assign(:car_search, CarSearch.create!(
      :user => nil,
      :from_title => "From Title",
      :to_title => "To Title",
      :from_m => "",
      :to_m => "",
      :pinned => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/From Title/)
    expect(rendered).to match(/To Title/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/false/)
  end
end
