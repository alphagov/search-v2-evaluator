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
end
