class FeedbacksController < ApplicationController
  def create
    @feedback = Feedback.new(feedback_params)

    # TODO: Implement unhappy path
    if @feedback.save
      flash[:success] = "Thank you for your feedback - it will help improve the new GOV.UK search."
    end

    redirect_to search_path
  end

private

  def feedback_params
    params.require(:feedback).permit(
      :search_query, :suggested_url, :comments, result_ratings: %i[content_id url position rating]
    )
  end
end
