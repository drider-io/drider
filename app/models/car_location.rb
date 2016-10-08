class CarLocation < ActiveRecord::Base
  belongs_to :user
  belongs_to :car_session

  scope :accurate, ->(accuracy=true) {
    if accuracy
      where('accuracy < 20')
    else
      where('accuracy < 400')
    end
  }

  scope :accurate400, -> { where('accuracy < 400') }
  scope :accurate2k, -> { where('accuracy <= 2000') }
  scope :unprocessed, -> { where(car_session_id: nil).accurate400.order(:id) }

  def time
    location_at || created_at
  end

  def location_at
    Time.at(location_time) if location_time.present?
  end
end
