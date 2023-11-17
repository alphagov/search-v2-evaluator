class SearchesController < ApplicationController
  def show
    @search = Search.new(query_params)
  end

private

  def query_params
    params.permit(:query, search_options: [])
  end
end
