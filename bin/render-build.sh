#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
yarn install
./bin/rails tailwindcss:build
./bin/rails assets:precompile
./bin/rails db:migrate
./bin/rails db:seed
