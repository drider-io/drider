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
      d_accept: {
        type: 'postback',
        title: 'Так',
        payload: 'd_accept'
      },
      d_decline: {
        type: 'postback',
        title: 'Ні',
        payload: 'd_decline'
      },
    }

    def self.get(*names)
      names.flatten.map {|name| BUTTONS[name] }
    end
  end
end
