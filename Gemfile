# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = { github: "openpoke/decidim", branch: "0.31-backports" }.freeze
gem "decidim", DECIDIM_VERSION
# gem "decidim-conferences", DECIDIM_VERSION
# gem "decidim-consultations", DECIDIM_VERSION
# gem "decidim-elections", DECIDIM_VERSION
# gem "decidim-initiatives", DECIDIM_VERSION
# gem "decidim-templates", DECIDIM_VERSION
gem "decidim-pokecode", github: "openpoke/decidim-module-pokecode", branch: "main"

gem "bootsnap", "~> 1.3"
gem "puma", ">= 6.3.1"


group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "brakeman"
  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web"
  gem "listen"
  gem "web-console"
end
