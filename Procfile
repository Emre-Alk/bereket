web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -C config/sidekiq.yml
stripe: stripe listen --forward-to https://appmynewproject-8b21a82c26ce.herokuapp.com/webhooks/stripe --forward-connect-to https://appmynewproject-8b21a82c26ce.herokuapp.com/webhooks/stripe
