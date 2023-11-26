class FeedbacksController < ApplicationController
  def create
    @feedback = Feedback.new(feedback_params)

    if @feedback.save
      flash[:success] = "Thank you for your feedback - it will help improve the new GOV.UK search."
      redirect_to search_path
    else
      @search = Search.new(query: @feedback.search_query)
      render "searches/show"
    end
  end

private

  def feedback_params
    params.require(:feedback).permit(
      :search_query, :suggested_url, :comments, result_ratings_attributes: {}
    )
  end
end
