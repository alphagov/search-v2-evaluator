source "https://rubygems.org"

ruby "3.3.1"

gem "rails", "~> 7.1.3"

gem "gds-api-adapters"
gem "govuk_app_config"
gem "govuk_publishing_components"

gem "google-cloud-bigquery"

gem "importmap-rails"
gem "sassc-rails"
gem "sprockets-rails"

group :development, :test do
  gem "brakeman", require: false
  gem "debug", platforms: %i[mri windows]
  gem "rspec-rails"
  gem "rubocop-govuk"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
