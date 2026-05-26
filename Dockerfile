FROM ruby:3.3.10 AS builder

RUN apt-get update && apt-get upgrade -y && apt-get install -y ca-certificates curl gnupg && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get update && apt-get install -y nodejs \
    build-essential \
    postgresql-client \
    p7zip \
    libpq-dev \
    nano \
    supervisor && \
    apt-get clean

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /app

# Copy package dependencies files only to ensure maximum cache hit
COPY ./package-lock.json /app/package-lock.json
COPY ./package.json /app/package.json
COPY ./packages /app/packages
COPY ./Gemfile /app/Gemfile
COPY ./Gemfile.lock /app/Gemfile.lock

RUN gem install bundler:$(grep -A 1 'BUNDLED WITH' Gemfile.lock | tail -n 1 | xargs) && \
    bundle install -j4 --retry 3 && \
    npm install yarn -g && \
    # Remove unneeded gems
    bundle clean --force && \
    # Remove unneeded files from installed gems (cache, *.o, *.c)
    rm -rf /usr/local/bundle/cache && \
    find /usr/local/bundle/ -name "*.c" -delete && \
    find /usr/local/bundle/ -name "*.o" -delete && \
    find /usr/local/bundle/ -name ".git" -exec rm -rf {} + && \
    find /usr/local/bundle/ -name ".github" -exec rm -rf {} + && \
    # Remove additional unneeded decidim files
    find /usr/local/bundle/ -name "spec" -exec rm -rf {} + && \
    find /usr/local/bundle/ -wholename "*/decidim-dev/lib/decidim/dev/assets/*" -exec rm -rf {} +

RUN npm ci

# copy the rest of files
COPY ./app /app/app
COPY ./bin /app/bin
COPY ./config /app/config
COPY ./db /app/db
COPY ./lib /app/lib
COPY ./public/*.* /app/public/
COPY ./config.ru /app/config.ru
COPY ./Rakefile /app/Rakefile
COPY ./postcss.config.js /app/postcss.config.js

# Compile assets with Webpacker or Sprockets
#
# Notes:
#   1. Executing "assets:precompile" runs "webpacker:compile", too
#   2. For an app using encrypted credentials, Rails raises a `MissingKeyError`
#      if the master key is missing. Because on CI there is no master key,
#      we hide the credentials while compiling assets (by renaming them before and after)
#
RUN mv config/credentials.yml.enc config/credentials.yml.enc.bak 2>/dev/null || true
RUN mv config/credentials config/credentials.bak 2>/dev/null || true

ENV RAILS_LOG_TO_STDOUT=""
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_ENV=development
ENV BUNDLE_WITHOUT=""

ARG RUN_RAILS
ARG RUN_SIDEKIQ

WORKDIR /app
COPY ./entrypoint.sh /app/entrypoint.sh
COPY ./supervisord.conf /etc/supervisord.conf

EXPOSE 3000
EXPOSE 3035
EXPOSE 3035/udp

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["/usr/bin/supervisord"]
