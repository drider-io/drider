class DownloadsController < ApplicationController

  def android
    send_file 'lib/downloads/android/drider_v1d.apk', :type => 'application/vnd.android.package-archive', :disposition => 'attachment'
  end
end