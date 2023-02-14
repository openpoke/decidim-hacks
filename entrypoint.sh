#!/bin/bash

# Temp files created by the container will be erasable by external user
umask 0000
bundle install
echo -e "\e[33mUpgrading Decidim..."
bin/rails decidim:upgrade

echo -e "\e[33mTrying to execute migrations..."
if bin/rails db:migrate; then
    echo -e "\e[32mDatabase already created. No need for seeding."
else
    echo -e "\e[31mMigration failed. Installing database"
    bin/rails db:create
    echo -e "\e[33mExecuting migrations..."
    bin/rails db:migrate
    echo -e "\e[32mDatabase just created so let's seed some data..."
    bin/rails db:seed
fi
echo -e "\e[33mSeeding hacks content..."
bin/rails db:seed:hacks

echo
echo -e "\e[32mGreat! Please use this user/password to login:"
echo
echo -e "\e[31madmin@example.org"
echo -e "\e[31mdecidim1234567890"
echo
echo -e "\e[33mStarting rails server..."
# bundle exec puma
bin/rails server -b 0.0.0.0