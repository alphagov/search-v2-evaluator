module ApplicationHelper
  def govuk_link_to(text, link)
    full_url = if link.start_with?("http")
                 link
               else
                 Plek.new.website_root + link
               end

    link_to text, full_url, class: "govuk-link"
  end
end
