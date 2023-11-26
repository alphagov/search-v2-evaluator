class SettingsController < ApplicationController
  def show; end

  def update
    flash[:success] = "Your settings have been updated."
    redirect_to settings_path
  end
end
