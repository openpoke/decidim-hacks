#!/bin/bash

# Temp files created by the container will be erasable by external user
umask 0000
# ensure latest updates
echo -e "\e[33mInstalling dependencies..."
bundle install
npm install
# # just in case to allow edits from the integrated browser editor
# find . \( -type d -exec chmod 777 {} \; \) -o \( -type f -exec chmod 666 {} \; \)
# chmod 777 entrypoint.sh bin/* node_modules/* -R
# chmod +X tmp -R

echo -e "\e[33mTrying to execute migrations..."
if bin/rails db:migrate; then
    echo -e "\e[32mDatabase already created. No need for seeding."
else
    echo -e "\e[31mMigration failed. Installing database"
    bin/rails db:create
    if [ -f "db/seeds.sql" ]; then
        echo -e "\e[33mSeeding database with db/seeds.sql..."
        PGPASSWORD=$DATABASE_PASSWORD psql -U $DATABASE_USERNAME -h $DATABASE_HOST -d decidim_hacks_development -f db/seeds.sql
    else
        echo -e "\e[32mDatabase just created so let's seed some data..."
        bin/rails db:migrate
        bin/rails db:seed
    fi
fi
echo -e "\e[33mSeeding hacks content..."
# Check no migrations are pending migrations
if [ -z "$SKIP_MIGRATIONS" ]; then
	bundle exec rails db:migrate
else
	echo "⚠️ Skipping migrations"
fi
bin/rails db:seed:hacks

echo
echo -e "\e[32mGreat! Please use this user/password to login:"
echo
echo -e "\e[31madmin@example.org"
echo -e "\e[31mdecidim123456789"
echo

echo "🚀 $@"
exec "$@"
