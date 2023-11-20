class ApplicationController < ActionController::Base
  if ENV["BASIC_AUTH_USERNAME"] && ENV["BASIC_AUTH_PASSWORD"]
    http_basic_authenticate_with(
      name: ENV.fetch("BASIC_AUTH_USERNAME"),
      password: ENV.fetch("BASIC_AUTH_PASSWORD"),
    )
  end
end
