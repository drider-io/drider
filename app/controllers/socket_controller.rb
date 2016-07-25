class SocketController < ApplicationController
  include Tubesock::Hijack

  def chat
      hijack do |tubesock|
        car_session = nil
        last_updated = Time.now - 1.day
        handshake_reply_sent = false
        tubesock.onopen do
          begin
          # car_session = Time.now.to_s
          # tubesock.send_data tubesock.object_id
          check_auth(tubesock)
          subscribe(tubesock) if user_signed_in?
          ensure
            ActiveRecord::Base.clear_active_connections!
          end
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
                if car_session.present?
                  save_location(json, car_session)
                  unless handshake_reply_sent
                    ReplyGeneric.new(tubesock).handshake_reply.send
                    handshake_reply_sent = true
                  end
                  if car_session.length.to_i > 500 && Time.now - last_updated > 10
                    ReplyGeneric.new(tubesock).exec_js("showSession(#{car_session.id})").send
                    last_updated = Time.now
                  end
                else
                  # tubesock.close
                  # raise StandardError.new 'location without handshake'

                  save_location(json, CarSession.new(id:0))
                end
              when 'handshake'
                if client_version_ok?(json)
                  car_session = CarSession.for_user(current_user, json)
                  reply = ReplyGeneric.new(tubesock)
                    .set_text(
                        render_to_string partial: 'driver/text_area',layout: false, locals:{ car_session: car_session}
                    )
                  reply.off_client if !json['ios'] && !car_session.is_location_available
                  reply.send
                else
                  reply = ReplyGeneric.new(tubesock)
                    .set_text('Потрібно оновити додаток')
                    .off_client.send
                end

            end

          p data
          end
          rescue StandardError=>e
            ExceptionNotifier.notify_exception(e, :env => request.env)
          ensure
            ActiveRecord::Base.clear_active_connections!
          end
        end

        tubesock.onclose do |data|
          CarLocationsProcessor.perform_in(15.minutes, car_session.id) if car_session
          @redis_thread.kill if @redis_thread.present?
        end
      end

  end

  def save_location(json, car_session)
    CarLocation.create!(
        r: RGeo::Geographic.spherical_factory(srid: 4326).point(json['long'], json['lat']),
        m: RGeo::Geographic.simple_mercator_factory(srid: 3785).point(json['long'], json['lat']).projection,
        car_session_id: car_session.id,
        accuracy: json['accy'],
        time: Time.at(json['time_ms'].to_f/1000),
        provider: json['prov'],
        user: current_user
    )
  end

  def handshake(json, sock)
    session = CarSession.where(
        user: current_user,
        number: json['session_number']
    ).first_or_initialize
    unless session.persisted?
      session.device_identifier = json['device_identifier']
      session.client_version = json['client_version']
      session.client_os_version = json['client_os_version']
      session.android_model = json['android_model']
      session.is_gps_available = json['is_gps_available']
      session.is_location_enabled = json['is_location_enabled']
      session.is_location_available = json['is_location_available']
      session.is_google_play_available = json['is_google_play_available']
      session.android_sdk = json['android_sdk']
      session.android_manufacturer = json['android_manufacturer']
      session.client_version_code = json['client_version_code']
      session.save!
    end
    if session.processed
      raise StandardError.new "atempt to handshake with processed car_session"
    end
    session
  end

  def check_auth(sock)
    ReplyGeneric.new(sock)
        .start_webview(url: new_user_session_url)
        .off_client
        .send and return false unless current_user
    true
  end

  def client_version_ok?(json)
    json['client_version_code'].to_i >= 4
  end


  private

  def subscribe(tubesock)
    @redis_thread = Thread.new do
      # Needs its own redis connection to pub
      # and sub at the same time
      Redis.new.subscribe "user_#{current_user.id}" do |on|
        on.message do |channel, message|
          tubesock.send_data message
        end
      end
    end
  end
end
