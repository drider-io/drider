class SocketController < ApplicationController
  include Tubesock::Hijack

  def chat
      hijack do |tubesock|
        tubesock.onopen do
          tubesock.close unless check_auth(tubesock)
        end

        tubesock.onmessage do |data|
          # tubesock.send_data "You said: #{data}"
          p "message received"
          parse_request(data, tubesock)
          p data
        end
      end
  end


  def parse_request(str, sock)
    json = JSON.parse str
    if json && json['type']
      case json['type']
        when 'location'
          # Point.create!(coordinates: [json['lat'], json['long']], accuracy: json['accy'], time: Time.at(json['time']))
          Point.create!(
              lonlat: RGeo::Geographic.spherical_factory(srid: 4326).point(json['lat'], json['long']),
              accuracy: json['accy'],
              time: Time.at(json['time'])
          )
        when 'handshake'
          handshake(json, sock)
      end

    end
  rescue StandardError

  end

  def handshake(json, sock)
    # reply = {
    #     type: 'webview',
    #     url: new_user_session_url
    # }
    # sock.send_data reply.to_json
  end

  def check_auth(sock)
    ReplyWebView.new(url: new_user_session).send(sock) and return false unless current_user
    true
  end
end