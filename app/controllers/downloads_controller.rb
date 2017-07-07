class DownloadsController < ApplicationController
  layout 'account'

  def android
    send_file 'lib/downloads/android/drider_v1.4.apk', :type => 'application/vnd.android.package-archive', :disposition => 'attachment'
  end
end
