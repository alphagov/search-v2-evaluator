module ApplicationHelper
  def govuk_link_to(text, link)
    full_url = if link.start_with?("http")
                 link
               else
                 Plek.new.website_root + link
               end

    link_to text, full_url, class: "govuk-link"
  end

  def show_more_results?
    ActiveModel::Type::Boolean.new.cast(cookies[:show_more_results])
  end

  def show_metadata?
    ActiveModel::Type::Boolean.new.cast(cookies[:show_metadata])
  end
end
