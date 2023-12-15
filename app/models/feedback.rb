require "google/cloud/bigquery"

class Feedback
  include ActiveModel::Model
  include ActiveModel::Validations

  validates :suggested_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true, message: "must be a valid URL" }

  attr_accessor :search_query, :result_ratings, :suggested_url, :comments, :user_id, :discovery_engine_attribution_token

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

    dataset = Google::Cloud::Bigquery.new.dataset(Rails.configuration.bigquery_dataset)
    table = dataset.table(Rails.configuration.bigquery_table)

    data = to_bigquery_row
    table.insert(data)
    Rails.logger.info "Feedback submitted: #{data.inspect}"
  end

  def to_bigquery_row
    {
      query_id: SecureRandom.uuid,
      anonymised_user_id: user_id,
      timestamp: Time.zone.now.utc.strftime("%Y-%m-%dT%H:%M:%S.%3NZ"),
      search_query:,
      result_ratings: result_ratings.map(&:to_bigquery_data),
      suggested_url:,
      comments:,
      discovery_engine_attribution_token:,
    }
  end
end
