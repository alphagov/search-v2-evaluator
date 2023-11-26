class ResultRating
  RATING_OPTIONS = {
    3 => "Perfect",
    2 => "Good",
    1 => "OK",
    0 => "Bad",
  }.freeze

  include ActiveModel::Model

  attr_accessor :content_id, :link, :position, :rating

  def self.rating_options
    RATING_OPTIONS
  end

  def id = content_id

  def to_bigquery_data
    {
      content_id:,
      url:,
      position: position + 1, # have it 1-indexed in BigQuery
      rating:,
    }
  end

  def url
    if link.start_with?("/")
      Plek.new.website_root + link
    else
      link
    end
  end
end
