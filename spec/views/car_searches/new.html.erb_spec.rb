require 'rails_helper'

RSpec.describe "car_searches/new", type: :view do
  before(:each) do
    assign(:car_search, CarSearch.new(
      :user => nil,
      :from_title => "MyString",
      :to_title => "MyString",
      :from_m => "",
      :to_m => "",
      :pinned => false
    ))
  end

  it "renders new car_search form" do
    render

    assert_select "form[action=?][method=?]", car_searches_path, "post" do

      assert_select "input#car_search_user_id[name=?]", "car_search[user_id]"

      assert_select "input#car_search_from_title[name=?]", "car_search[from_title]"

      assert_select "input#car_search_to_title[name=?]", "car_search[to_title]"

      assert_select "input#car_search_from_m[name=?]", "car_search[from_m]"

      assert_select "input#car_search_to_m[name=?]", "car_search[to_m]"

      assert_select "input#car_search_pinned[name=?]", "car_search[pinned]"
    end
  end
end
