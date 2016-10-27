module FbApi
  class Buttons
    BUTTONS = {
      go: {
        type: 'postback',
        title: 'Їхати',
        payload: 'new_search'
      }
    }

    def self.get(*names)
      names.flatten.map {|name| BUTTONS[name] }
    end
  end
end
