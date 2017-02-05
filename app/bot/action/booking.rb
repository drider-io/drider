class Action::Booking
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def from(coordinates)
    m = GeoLocation.new.to_m(coordinates['lat'].to_s, coordinates['long'].to_s)
    address = GeoLocation.new(location: m).address
    car_search = CarSearch.new(from_m: m, from_title: address)
    user.last_search = car_search

    if CarRouteSearcher.new.pass_by(m)
      car_search.has_results = true
      FbMessage.new(@message.sender['id']).quick_replies(text: 'ok', replies: :location).deliver
      user.p_from_entered!
    else
      car_search.has_results = false
      FbMessage.new(@message.sender['id']).quick_replies(text: 'На жаль, звідси ніхто не може підвезти', replies: :location).deliver
    end
    user.save!
  end
end
