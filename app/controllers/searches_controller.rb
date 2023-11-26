class SearchesController < ApplicationController
  def show
    @search = Search.new(query_params)
    @feedback = Feedback.new(search_query: @search.query)
  end

private

  def query_params
    params.permit(:query).merge(count: show_more_results? ? 10 : 5)
  end

  def show_more_results?
    ActiveModel::Type::Boolean.new.cast(cookies[:show_more_results])
  end
  helper_method :show_more_results?

  def show_metadata?
    ActiveModel::Type::Boolean.new.cast(cookies[:show_metadata])
  end
  helper_method :show_metadata?
end
