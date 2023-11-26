class SettingsController < ApplicationController
  SETTINGS_KEYS = %i[show_more_results show_metadata].freeze

  def show
    @settings = SETTINGS_KEYS.index_with do |key|
      ActiveModel::Type::Boolean.new.cast(cookies[key])
    end
  end

  def update
    SETTINGS_KEYS.each do |key|
      cookies.permanent[key] = ActiveModel::Type::Boolean.new.cast(settings_params[key])
    end

    flash[:success] = "Your settings have been updated."
    redirect_to settings_path
  end

private

  def settings_params
    params.permit(*SETTINGS_KEYS)
  end
end
