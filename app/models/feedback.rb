class Feedback
  include ActiveModel::Model
  include ActiveModel::Validations

  validates :suggested_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true, message: "must be a valid URL" }

  attr_accessor :search_query, :result_ratings, :suggested_url, :comments

  def result_ratings_attributes=(attributes)
    @result_ratings = attributes.map do |_, v|
      ResultRating.new(
        content_id: v["content_id"],
        link: v["link"],
        position: v["position"].to_i,
        rating: v["rating"].presence&.to_i, # nil rating is legitimate, don't convert to zero
      )
    end
  end

  def save
    return false unless valid?

    # TODO: Implement me!
    Rails.logger.info "Feedback submitted: #{inspect}"
    true
  end
end
