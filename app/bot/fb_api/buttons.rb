module FbApi
  class Buttons
    BUTTONS = {
      go: {
        type: 'postback',
        title: 'Їхати',
        payload: 'new_search'
      },
      go_now: {
        type: 'postback',
        title: 'Зараз',
        payload: 'go_now'
      },
      p_cancel: {
        type: 'postback',
        title: 'Відмінити',
        payload: 'p_cancel'
      },
      select_driver: {
        type: 'postback',
        title: 'Я водій',
        payload: 'select_driver'
      },
      select_rider: {
        type: 'postback',
        title: 'Я пасажир',
        payload: 'select_rider'
      },
      app_ios: {
        type: 'web_url',
        title: 'iOS',
        url: 'fb1589454371319440://applink' #https://itunes.apple.com/ua/app/drider/id1101420670?ls=1&mt=8
      },
      app_android: {
        type: 'web_url',
        title: 'Android',
        url: 'https://play.google.com/store/apps/details?id=io.drider.car&utm_source=global_co&utm_medium=prtnr&utm_content=Mar2515&utm_campaign=PartBadge&pcampaignid=MKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'
      },
    }

    def self.get(*names)
      names.flatten.map do |name|
        if name.is_a? Symbol
          BUTTONS[name]
        else
          name
        end
      end
    end
  end
end
