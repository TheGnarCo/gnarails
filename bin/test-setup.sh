sh ./bin/generate-test-app.sh

cd rails-test-app
bundle
bundle exec rake db:drop
bundle exec rake db:setup
bundle exec rails db:migrate
cd ..
