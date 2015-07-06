require 'rails_helper'

RSpec.describe "messages/new", type: :view do
  before(:each) do
    assign(:message, Message.new(
      :from => 1,
      :to => 1,
      :car_request => 1,
      :body => "MyString"
    ))
  end

  it "renders new message form" do
    render

    assert_select "form[action=?][method=?]", messages_path, "post" do

      assert_select "input#message_from[name=?]", "message[from]"

      assert_select "input#message_to[name=?]", "message[to]"

      assert_select "input#message_car_request[name=?]", "message[car_request]"

      assert_select "input#message_body[name=?]", "message[body]"
    end
  end
end
