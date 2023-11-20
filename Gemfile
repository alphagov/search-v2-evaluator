source "https://rubygems.org"

ruby "3.2.2"

gem "rails", "~> 7.1.2"

gem "gds-api-adapters"
gem "govuk_app_config"
gem "govuk_publishing_components"

gem "importmap-rails"
gem "sassc-rails"
gem "sprockets-rails"

group :development, :test do
  gem "brakeman", require: false
  gem "debug", platforms: %i[mri windows]
  gem "rubocop-govuk"
end

group :development do
  gem "web-console"
end
