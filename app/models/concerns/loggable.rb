module Loggable
  extend ActiveSupport::Concern

  included do
    def get_log
      @log
    end

    def log(str)
      @log ||= ''
      @log += str + "\n"
    end

    def save_log(parent)
      DetailsLog.create parent: parent, info: @log
    end
  end
end
