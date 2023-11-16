require "gds_api/search"

class Search
  MAX_RESULTS = 3

  include ActiveModel::Model

  attr_accessor :query

  def results
    response["results"].map do |result|
      Result.new(
        title: result["title"],
        description: result["description_with_highlighting"],
        link: result["link"],
        content_id: result["content_id"],
        document_type: result["content_store_document_type"],
      )
    end
  end

  def displayed_count
    response["results"].size
  end

  def total_count
    response["total"]
  end

private

  def response
    @response ||= search_service.search(
      q: query,
      count: MAX_RESULTS,
    ).to_hash
  end

  def search_service
    @search_service ||= ::GdsApi::SearchApiV2.new(Plek.find("search-api-v2"))
  end
end
