require "gds_api/search"

class Search
  include ActiveModel::Model

  attr_accessor :query, :count

  def show_results?
    query.present?
  end

  def results
    response["results"].map do |result|
      timestamp = Time.zone.parse(result["public_timestamp"])

      Result.new(
        title: result["title"],
        description: result["description_with_highlighting"],
        link: result["link"],
        content_id: result["content_id"],
        document_type: result["content_store_document_type"],
        public_timestamp: timestamp,
        parts: (result["parts"] || []).map { |part| part["title"] },
      )
    end
  end

  def displayed_count
    response["results"].size
  end

  def total_count
    response["total"]
  end

  def discovery_engine_attribution_token
    response["discovery_engine_attribution_token"]
  end

private

  def response
    @response ||= search_service.search(
      q: query,
      count:,
    ).to_hash
  end

  def search_service
    @search_service ||= ::GdsApi::SearchApiV2.new(Plek.find("search-api-v2"))
  end
end
