class ApplicationController < ActionController::Base
  if ENV["BASIC_AUTH_USERNAME"] && ENV["BASIC_AUTH_PASSWORD"]
    http_basic_authenticate_with(
      name: ENV.fetch("BASIC_AUTH_USERNAME"),
      password: ENV.fetch("BASIC_AUTH_PASSWORD"),
    )
  end

private

  def user_id
    cookies[:user_id] ||= SecureRandom.uuid
  end

  def show_more_results?
    ActiveModel::Type::Boolean.new.cast(cookies[:show_more_results])
  end
  helper_method :show_more_results?

  def show_metadata?
    ActiveModel::Type::Boolean.new.cast(cookies[:show_metadata])
  end
  helper_method :show_metadata?
end
