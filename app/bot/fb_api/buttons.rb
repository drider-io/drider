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
