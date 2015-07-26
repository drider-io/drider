class DownloadsController < ApplicationController
  before_action :user_required

  def android
    send_file 'lib/downloads/android/drider_v1.apk', :type => 'application/vnd.android.package-archive', :disposition => 'attachment'
  end
end