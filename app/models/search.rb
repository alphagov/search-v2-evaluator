class Search
  include ActiveModel::Model

  attr_accessor :query

  def results
    [
      {
        link: {
          text: "Test result for #{query}",
          path: "/test",
          description: "Lorem ipsum dolor sit amet.",
        },
        metadata: {
          public_updated_at: Time.parse("2021-11-25T10:15:49.000+00:00"),
          document_type: "travel_advice",
        },
      },
    ] * 5
  end
end
