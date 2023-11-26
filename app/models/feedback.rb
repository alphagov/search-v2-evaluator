class Feedback
  include ActiveModel::Model

  attr_accessor :search_query, :result_ratings, :suggested_url, :comments

  def save
    # TODO: Implement me!
    Rails.logger.info "Feedback submitted: #{inspect}"
    false
  end
end
