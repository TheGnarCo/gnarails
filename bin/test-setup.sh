#!/bin/bash
echo "Running test setup"
rails new rails-test-app -m gnarly.rb --skip-test-unit --database=postgresql

echo "Staging sample application files"
# Move all sample functionality
cp spec/support/test-app/app/controllers/job_postings_controller.rb
rails-test-app/app/controllers/job_postings_controller.rb
cp spec/support/test-app/app/models/job_posting.rb
rails-test-app/app/controllers/job_posting.rb
cp spec/support/test-app/app/views/job_postings/index.html.erb
rails-test-app/app/views/job_postings/index.html.erb
yes | cp spec/support/test-app/config/routes.rb rails-test-app/config.routes.rb
cp spec/support/test-app/db/migrate/20170918002433_create_job_postings.rb
rails-test-app/db/migrate/20170918002433_create_job_postings.rb
cp spec/support/test-app/spec/factories/job_postings.rb
rails-test-app/spec/factories/job_postings.rb
cp spec/support/test-app/spec/models/job_posting_spec.rb
rails-test-app/spec/models/job_posting_spec.rb
cp spec/support/test-app/spec/system/viewing_all_job_postings_spec.rb
rails-test-app/spec/system/viewing_all_job_postings_spec.rb

echo "Setting up sample application"
# Set up application
cd rails-test-app
bundle install
bundle exec rake db:setup
bundle exec rails db:migrate
