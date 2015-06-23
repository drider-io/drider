class SocketController < ApplicationController
  include Tubesock::Hijack

  def chat
      hijack do |tubesock|
        car_session = nil
        handshake_reply_sent = false
        tubesock.onopen do
          # car_session = Time.now.to_s
          tubesock.send_data tubesock.object_id
          check_auth(tubesock)
        end

        tubesock.onmessage do |data|
          begin
          # tubesock.send_data "You said: #{data}"
          # p "message received"
          # tubesock.send_data tubesock.object_id
          # tubesock.send_data car_session
          json = JSON.parse data
          if json && json['type']
            case json['type']
              when 'location'
                save_location(json, car_session)
                unless handshake_reply_sent
                  ReplyGeneric.new(tubesock).handshake_reply.send
                  handshake_reply_sent = true
                end
              when 'handshake'
                car_session = handshake(json, tubesock)
            end

          p data
          end
          rescue StandardError=>e
            p e
          end
        end
      end

  end

  def save_location(json, car_session)
    CarLocation.create!(
        r: RGeo::Geographic.spherical_factory(srid: 4326).point(json['long'], json['lat']),
        m: RGeo::Geographic.simple_mercator_factory(srid: 3857).point(json['long'], json['lat']).projection,
        car_session: car_session,
        accuracy: json['accy'],
        time: Time.at(json['time']),
        provider: json['prov'],
        user: current_user
    )
  end

  def handshake(json, sock)
    CarSession.where(
        user: current_user,
        number: json['time'],
        device_identifier: json['device_identifier'],
        client_version: json['client_version'],
        client_os_version: json['client_os_version']
    ).first_or_create
  end

  def check_auth(sock)
    ReplyGeneric.new(sock)
        .start_webview(url: new_user_session_url)
        .stop_client
        .send and return false unless current_user
    true
  end
end