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
