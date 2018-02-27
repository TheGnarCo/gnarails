#!/bin/bash
ruby -v
echo "Running test setup"
rails new rails-test-app -m gnarly.rb --skip-test-unit --database=postgresql

echo "Staging sample application files"
mkdir rails-test-app/app/views/job_postings
mkdir rails-test-app/db/migrate
mkdir rails-test-app/spec/factories
mkdir rails-test-app/spec/models
mkdir rails-test-app/spec/system

cp test-app/app/controllers/job_postings_controller.rb rails-test-app/app/controllers/job_postings_controller.rb
cp test-app/app/models/job_posting.rb rails-test-app/app/models/job_posting.rb
cp test-app/app/views/job_postings/index.html.erb rails-test-app/app/views/job_postings/index.html.erb
yes | cp test-app/app/views/layouts/application.html.erb rails-test-app/app/views/layouts/application.html.erb
yes | cp test-app/config/routes.rb rails-test-app/config/routes.rb
cp test-app/db/migrate/20170918002433_create_job_postings.rb rails-test-app/db/migrate/20170918002433_create_job_postings.rb
cp test-app/spec/factories/job_postings.rb rails-test-app/spec/factories/job_postings.rb
cp test-app/spec/models/job_posting_spec.rb rails-test-app/spec/models/job_posting_spec.rb
cp test-app/spec/system/viewing_all_job_postings_spec.rb rails-test-app/spec/system/viewing_all_job_postings_spec.rb

echo "Setting up sample application"
(cd rails-test-app && bundle && bundle exec rake db:drop && bundle exec rake db:setup && bundle exec rails db:migrate)
