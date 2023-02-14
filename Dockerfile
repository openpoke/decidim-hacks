FROM ruby:3.0 AS builder
LABEL maintainer="ivan@pokecode.net"

RUN apt-get update && apt-get upgrade -y && apt-get install gnupg2 && \
    curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y nodejs yarn \
    build-essential \
    postgresql-client \
    imagemagick \
    libpq-dev \
    supervisor && \
    apt-get clean

WORKDIR /app

# Copy package dependencies files only to ensure maximum cache hit
COPY ./package-lock.json /app/package-lock.json
COPY ./package.json /app/package.json
COPY ./Gemfile /app/Gemfile
COPY ./Gemfile.lock /app/Gemfile.lock

RUN bundle update --bundler && \
		bundle install -j4 --retry 3 && \
    # Remove unneeded gems
    bundle clean --force && \
    # Remove unneeded files from installed gems (cache, *.o, *.c)
    rm -rf /usr/local/bundle/cache && \
    find /usr/local/bundle/ -name "*.c" -delete && \
    find /usr/local/bundle/ -name "*.o" -delete && \
    find /usr/local/bundle/ -name ".git" -exec rm -rf {} + && \
    find /usr/local/bundle/ -name ".github" -exec rm -rf {} + && \
    # whkhtmltopdf has binaries for all platforms, we don't need them once uncompressed
    rm -rf /usr/local/bundle/gems/wkhtmltopdf-binary-*/bin/*.gz && \
    # Remove additional unneded decidim files
    find /usr/local/bundle/ -name "decidim_app-design" -exec rm -rf {} + && \
    find /usr/local/bundle/ -name "spec" -exec rm -rf {} +


COPY ./supervisord.conf /etc/supervisord.conf 
# copy the rest of files
COPY . /app
# Add user
RUN addgroup --system --gid 1000 app && \
    adduser --system --uid 1000 --home /app --group app && \
    chown -R app:app /app

USER app
RUN npm ci

ENV RAILS_LOG_TO_STDOUT=1
ENV RAILS_SERVE_STATIC_FILES=1
ENV RAILS_ENV=development

EXPOSE 3000
EXPOSE 3035
EXPOSE 3035/udp

CMD ["/usr/bin/supervisord"]