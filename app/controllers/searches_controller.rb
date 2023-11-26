class SearchesController < ApplicationController
  def show
    @search = Search.new(query_params)
    @feedback = Feedback.new(search_query: @search.query)
  end

private

  def query_params
    params.permit(:query).merge(count: show_more_results? ? 10 : 5)
  end
end
