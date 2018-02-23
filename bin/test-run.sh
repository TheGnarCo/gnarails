#!/bin/bash
sh ./bin/test-setup.sh
#Test sample app
cd rails-test-app
bundle exec rspec

cd ..
bundle exec rspec
