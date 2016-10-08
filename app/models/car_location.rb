class CarLocation < ActiveRecord::Base
  belongs_to :user
  belongs_to :car_session

  scope :accurate, ->(accuracy=true) {
    if accuracy
      where('accuracy < 20')
    else
      where('accuracy < 500')
    end
  }

  scope :accurate500, -> { where('accuracy < 500') }
  scope :accurate2k, -> { where('accuracy <= 2000') }
  scope :unprocessed, -> { where(car_session_id: nil).accurate500.order(:id) }

  def time
    location_at || created_at
  end

  def location_at
    Time.at(location_time) if location_time.present?
  end
end
