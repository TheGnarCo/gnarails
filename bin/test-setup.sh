#!/bin/bash
echo "Running test setup"
rails new rails-test-app -m gnarly.rb --skip-test-unit --database=postgresql
