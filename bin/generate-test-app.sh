#!/bin/bash
chown -R $USER:$USER .
bundle exec exe/gnarails new rails-test-app

mkdir rails-test-app/app/views/job_postings
mkdir rails-test-app/db/migrate
mkdir rails-test-app/spec/factories
mkdir rails-test-app/spec/models
mkdir rails-test-app/spec/system
mkdir rails-test-app/spec/requests

# echo "Note! CI is not allowing our build scripts to write to package.json"
# echo "Note! This package.json may need to be updated in the future."
# cp test-app/package.json rails-test-app/package.json
cp test-app/app/controllers/job_postings_controller.rb rails-test-app/app/controllers/job_postings_controller.rb
cp test-app/app/models/job_posting.rb rails-test-app/app/models/job_posting.rb
cp test-app/app/models/comment.rb rails-test-app/app/models/comment.rb
cp test-app/app/views/job_postings/index.html.erb rails-test-app/app/views/job_postings/index.html.erb
yes | cp test-app/app/views/layouts/application.html.erb rails-test-app/app/views/layouts/application.html.erb
yes | cp test-app/config/routes.rb rails-test-app/config/routes.rb
cp test-app/db/migrate/20170918002433_create_job_postings.rb rails-test-app/db/migrate/20170918002433_create_job_postings.rb
cp test-app/db/migrate/20170918002455_create_comments.rb rails-test-app/db/migrate/20170918002455_create_comments.rb
cp test-app/spec/factories/job_postings.rb rails-test-app/spec/factories/job_postings.rb
cp test-app/spec/models/job_posting_spec.rb rails-test-app/spec/models/job_posting_spec.rb
cp test-app/spec/system/viewing_all_job_postings_spec.rb rails-test-app/spec/system/viewing_all_job_postings_spec.rb
cp test-app/spec/requests/status_spec.rb rails-test-app/spec/requests/status_spec.rb
