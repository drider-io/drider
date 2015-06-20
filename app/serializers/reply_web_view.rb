class ReplyWebView < ReplyGeneric
  def initialize(url: )
    @hash = {
        type: 'webview',
        url: url
    }
  end
end