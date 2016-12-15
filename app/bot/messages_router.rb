class MessagesRouter

  def initialize(message)
    @message = message
  end

  def perform
    return if @message.messaging['message']['is_echo']
    user = User.where(fb_chat_id: @message.sender['id']).first
    if user.present?
      p @message
      case user.bot_state
        when 'p_from'
          # address = GeoLocation.new(address: @message.text).address_double_code
          # if address != @message.text
          #   FbMessage.new(@message.sender['id'])
          #     .quick_replies(text: "Може ви мали на увазі '#{address}'?", replies: {
          #       content_type:"text",
          #       title: "Так",
          #       payload:"DEVELOPER_DEFINED_PAYLOAD_FOR_PICKING_RED"
          #     }
          #     ).deliver
          #
          #
          # end
          if @message.try(:attachments).try(:first).try(:[], 'type') == 'location'
            coordinates = @message.attachments.first['payload']['coordinates']
            if coordinates.present?
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
          else
            FbMessage.new(@message.sender['id']).quick_replies(text: 'На разі тільки координата (можна відправити з мобільного)', replies: :location).deliver
          end
        when 'p_to'
          if @message.try(:attachments).try(:first).try(:[], 'type') == 'location'
            coordinates = @message.attachments.first['payload']['coordinates']
            if coordinates.present?
              m = GeoLocation.new.to_m(coordinates['lat'].to_s, coordinates['long'].to_s)
              address = GeoLocation.new(location: m).address
              car_search = user.last_search
              if car_search.to_m.present?
                car_search = user.last_search = car_search.dup
              end

              car_search.to_m = m
              car_search.to_title = address
              car_search.save!
              drivers_count = CarRouteSearcher.new.drivers_count(car_search)
              if drivers_count > 0
                car_search.has_results = true

                FbMessage.new(@message.sender['id']).button_template(text: "Знайдено #{drivers_count} водіїв, коли іхати ?", buttons: [:go_now, :p_cancel]).deliver
                user.p_to_entered!
              else
                car_search.has_results = false
                FbMessage.new(@message.sender['id']).quick_replies(text: 'На жаль, сюди ніхто не може підвезти', replies: :location).deliver
              end

              user.save!
            end
          else
            FbMessage.new(@message.sender['id']).quick_replies(text: 'На разі тільки координата (можна відправити з мобільного)', replies: :location).deliver
          end
        else
          FbMessage.new(@message.sender['id'])
            .button_template(text: 'Чим можу допомогти ?', buttons: [:go])
            .deliver
      end
    else
      FbMessage.new(@message.sender['id']).account_link.deliver
    end
  end
end
