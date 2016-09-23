class LocationsProcessor
  include Loggable

  MIN_ROUTE_DISTANCE = 5000
  SAME_PLACE_RADIUS = 4000
  MIN_IDLE_TIME = 1.hour

  def perform
    user = user_to_process
    find_route user
  end

  private

  # route finish criteria:
  #  - no move within 1 hour
  #  - route distance > 5km
  def find_route(user)
    first_location = nil
    last_location = nil

    pipe = []
    CarLocation.unprocessed.where(user: user).find_each do |location|
      unless first_location
        first_location = location
        pipe << location
        log "first location id:#{first_location.id}, time:#{first_location.time}"
        next
      end

      last_location = pipe.first
      while pipe.first && !within_same_place?(pipe.first,location)
        last_location = pipe.shift
      end

      if idle_between?(last_location, location)
        if within_same_place?(first_location, location)
          log "skip location:#{location.id} as it close to first_location"
        else
          log "idle between #{last_location.id}-#{location.id} [#{last_location.time.strftime("%H:%M")}-#{location.time.strftime("%H:%M")}]"
          log "create session between locations: (#{first_location.id}..#{last_location.id})"
          # create session
          ActiveRecord::Base.transaction do
            session = CarSession.create(accurate: false, user: user, number:Time.now.to_i,device_identifier:'1',client_version:'1',client_os_version:'1')
            save_log(session)
            CarLocation.unprocessed.where(user: user)
                .where('id >= ?', first_location.id)
                .where('id <= ?', last_location.id)
                .all.update_all(car_session_id: session.id)

            CarLocationsProcessor.new.perform(session.id)
          end
          break
        end
      end
      pipe << location

    end
  end

  def idle_between?(location1, location2)
    (location2.time - location1.time).abs > MIN_IDLE_TIME
  end

  def within_same_place?(location1, location2)
    location1.m.distance(location2.m) < SAME_PLACE_RADIUS
  end

  def locations_time_distance

  end

  def user_to_process
    CarLocation.where(car_session: nil).order(:id).first.try(:user)
  end
end