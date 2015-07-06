require 'rails_helper'

RSpec.describe "car_searches/index", type: :view do
  before(:each) do
    assign(:car_searches, [
      CarSearch.create!(
        :user => nil,
        :from_title => "From Title",
        :to_title => "To Title",
        :from_m => "",
        :to_m => "",
        :pinned => false
      ),
      CarSearch.create!(
        :user => nil,
        :from_title => "From Title",
        :to_title => "To Title",
        :from_m => "",
        :to_m => "",
        :pinned => false
      )
    ])
  end

  it "renders a list of car_searches" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "From Title".to_s, :count => 2
    assert_select "tr>td", :text => "To Title".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
