require 'rails_helper'

RSpec.describe "messages/index", type: :view do
  before(:each) do
    assign(:messages, [
      Message.create!(
        :from => 1,
        :to => 2,
        :car_request => 3,
        :body => "Body"
      ),
      Message.create!(
        :from => 1,
        :to => 2,
        :car_request => 3,
        :body => "Body"
      )
    ])
  end

  it "renders a list of messages" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Body".to_s, :count => 2
  end
end
