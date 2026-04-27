# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

gem "decidim", "0.27.1"
# gem "decidim-conferences", "0.27.1"
# gem "decidim-consultations", "0.27.1"
# gem "decidim-elections", "0.27.1"
# gem "decidim-initiatives", "0.27.1"
# gem "decidim-templates", "0.27.1"

gem "bootsnap"
gem "puma"


group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "brakeman"
  gem "decidim-dev", "0.27.1"
end

group :development do
  gem "letter_opener_web"
  gem "listen"
  gem "web-console"
end
