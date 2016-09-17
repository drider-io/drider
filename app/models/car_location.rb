class CarLocation < ActiveRecord::Base
  belongs_to :user
  belongs_to :car_session

  scope :accurate, ->(accuracy=true) {
    if accuracy
      where('accuracy < 20')
    end
  }
  scope :accurate2k, -> { where('accuracy <= 2000') }
  scope :unprocessed, -> { where(car_session_id: nil).accurate2k.order(:id) }

  def time
    created_at
  end
end
