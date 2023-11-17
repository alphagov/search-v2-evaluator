class FeedbacksController < ApplicationController
  def create
    flash[:success] = "Thank you for your feedback - it will help improve the new GOV.UK search."
    redirect_back fallback_location: search_path
  end
end
