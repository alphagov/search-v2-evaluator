class SearchesController < ApplicationController
  def show
    @search = Search.new(query_params)
    @feedback = Feedback.new(
      search_query: @search.query,
      result_ratings: @search.results.map.with_index { |r, i| ResultRating.new(content_id: r.content_id, link: r.link, position: i) },
      discovery_engine_attribution_token: @search.discovery_engine_attribution_token,
    )
  end

private

  def query_params
    params.permit(:query).merge(count: show_more_results? ? 10 : 5)
  end
end
