class SearchesController < ApplicationController
  def show
    @search = Search.new(query_params)
    @feedback = Feedback.new(search_query: @search.query)
  end

private

  def query_params
    params.permit(:query, search_options: [])
  end
end
