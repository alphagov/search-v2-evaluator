class ResultRating
  RATING_OPTIONS = {
    0 => "Bad",
    1 => "OK",
    2 => "Good",
    3 => "Perfect",
  }.freeze

  include ActiveModel::Model

  attr_accessor :content_id, :url, :position, :rating

  def self.rating_options
    RATING_OPTIONS
  end
end
