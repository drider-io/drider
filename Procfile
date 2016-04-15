web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -q default -q mailers
rpush: bundle exec rpush start -f --rails-env=$RAILS_ENV
