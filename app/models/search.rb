class Search
  include ActiveModel::Model

  attr_accessor :query

  def results
    displayed_count.times.map do |i|
      Result.new(
        title: "Foo",
        description: "Bar",
        link: "http://example.com/foo",
        metadata: { foo: "bar" },
        content_id: "0000-0000-0000-000#{i}",
        document_type: "foo",
      )
    end
  end

  def displayed_count
    3
  end

  def total_count
    42
  end
end
