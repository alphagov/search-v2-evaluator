class Feedback
  include ActiveModel::Model
  include ActiveModel::Validations

  validates :suggested_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true, message: "must be a valid URL" }

  attr_accessor :search_query, :result_ratings, :suggested_url, :comments

  def save
    return false unless valid?

    # TODO: Implement me!
    Rails.logger.info "Feedback submitted: #{inspect}"
    true
  end
end
