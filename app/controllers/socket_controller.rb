class SocketController < ApplicationController
  include Tubesock::Hijack

  def chat
      hijack do |tubesock|
        tubesock.onopen do
          tubesock.send_data "Hello, friend"
        end

        tubesock.onmessage do |data|
          tubesock.send_data "You said: #{data}"
          p "message received"
          parse_request(data)
          p data
        end
      end
  end


  def parse_request(str)
    json = JSON.parse str
    if json && json['type']
      case json['type']
        when 'location'
          Point.create!(coordinates: [json['lat'], json['long']], accuracy: json['accy'], time: Time.at(json['time']))

      end

    end
  rescue StandardError

  end


end