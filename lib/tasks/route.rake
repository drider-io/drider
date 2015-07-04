namespace :route do
  desc "Create/Update CarRoutes from CarLocations"
  task update: :environment do
    logger           = Logger.new(STDOUT)
    logger.level     = Logger::INFO
    Rails.logger     = logger

    CarLocationsProcessor.new(logger: logger).process
  end


end
