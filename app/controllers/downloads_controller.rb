class DownloadsController < ApplicationController

  def android
    send_file 'lib/downloads/android/drider_v1.1.apk', :type => 'application/vnd.android.package-archive', :disposition => 'attachment'
  end
end