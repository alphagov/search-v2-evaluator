require "google/cloud/bigquery"

RSpec.describe "Submitting feedback", type: :system do
  let(:search_service) { double("Search service", search:) }
  let(:search) do
    { "results" => [
        { "content_id" => "3fc2d1a1-bc9b-4875-899a-54a1fd968175",
          "title" => "GDS blog",
          "link" => "https://gds.blog.gov.uk/",
          "content_purpose_supergroup" => "other",
          "_id" => "3fc2d1a1-bc9b-4875-899a-54a1fd968175",
          "description_with_highlighting" =>
       "The Government Digital Service (GDS) blog about how the government is transforming digital public services.",
          "format" => "external_content",
          "public_timestamp" => "2017-12-21T09:45:01+00:00",
          "content_store_document_type" => "external_content",
          "is_historic" => false },
        { "content_id" => "af07d5a5-df63-4ddc-9383-6a666845ebe9",
          "title" => "Government Digital Service",
          "link" => "/government/organisations/government-digital-service",
          "content_purpose_supergroup" => "other",
          "_id" => "/government/organisations/government-digital-service",
          "description_with_highlighting" =>
          "We are here to make digital government simpler, clearer and faster for everyone. GDS is part of the Cabinet Office .",
          "format" => "organisation",
          "public_timestamp" => "2023-08-08T17:10:39+01:00",
          "content_store_document_type" => "organisation",
          "is_historic" => false },
        { "content_id" => "27f58621-a0d0-44fc-8c3a-4548245c6079",
          "title" => "Government Digital Service IT platform privacy notice",
          "link" => "/government/publications/government-digital-service-it-platform-privacy-notice",
          "content_purpose_supergroup" => "guidance_and_regulation",
          "government_name" => "2015 Conservative government",
          "_id" => "/government/publications/government-digital-service-it-platform-privacy-notice",
          "description_with_highlighting" =>
          "Find details here about the privacy policy for the Government Digital Service's internal IT platform, and how we collect and process your data. ",
          "format" => "guidance",
          "public_timestamp" => "2022-11-18T12:00:04+00:00",
          "content_store_document_type" => "guidance",
          "is_historic" => false },
      ],
      "total" => 28_766,
      "start" => 0 }
  end

  let(:bigquery) { double("BigQuery client", dataset: bigquery_dataset) }
  let(:bigquery_dataset) { double("BigQuery dataset") }
  let(:bigquery_table) { double("BigQuery table", insert: nil) }

  before do
    allow(Plek).to receive(:find).with("search-api-v2").and_return("https://example.com/v2")
    allow(GdsApi::SearchApiV2).to receive(:new).with("https://example.com/v2")
      .and_return(search_service)
    allow(Google::Cloud::Bigquery).to receive(:new).and_return(bigquery)
    allow(bigquery).to receive(:dataset).with("search_feedback").and_return(bigquery_dataset)
    allow(bigquery_dataset).to receive(:table).with("evaluator_ratings").and_return(bigquery_table)
  end

  scenario "performing a basic search and submitting result-level feedback" do
    perform_search

    # Makes the right query to the search API v2
    expect(search_service).to have_received(:search).with(count: 5, q: "government digital service")

    # Renders the proper results
    expect(page).to have_content("Showing top 3 results (out of 28,766)")

    # Renders external and internal links properly
    expect(page).to have_link("GDS blog", href: "https://gds.blog.gov.uk/")
    expect(page).to have_link("Government Digital Service", href: "http://www.dev.gov.uk/government/organisations/government-digital-service")
  end

  scenario "submitting feedback" do
    perform_search

    # Allows the user to submit feedback for results (and leave some blank)
    within(all(".search-results__ranking")[0]) { choose "Perfect" }
    within(all(".search-results__ranking")[2]) { choose "Bad" }
    click_on "Submit feedback"

    # Sends the right data to Bigquery
    expect(bigquery_table).to have_received(:insert).with(
      hash_including(
        result_ratings: [{ content_id: "3fc2d1a1-bc9b-4875-899a-54a1fd968175",
                           position: 1,
                           rating: 3,
                           url: "https://gds.blog.gov.uk/" },
                         { content_id: "af07d5a5-df63-4ddc-9383-6a666845ebe9",
                           position: 2,
                           rating: nil,
                           url: "http://www.dev.gov.uk/government/organisations/government-digital-service" },
                         { content_id: "27f58621-a0d0-44fc-8c3a-4548245c6079",
                           position: 3,
                           rating: 0,
                           url: "http://www.dev.gov.uk/government/publications/government-digital-service-it-platform-privacy-notice" }],
        search_query: "government digital service",
        timestamp: a_string_matching(Time.zone.now.strftime("%Y-%m-%d")),
      ),
    )

    # Shows a nice message
    expect(page).to have_content("Thank you for your feedback")
  end

  scenario "submitting feedback with a suggested URL and comments" do
    perform_search

    # Allows the user to give a suggested URL
    fill_in "URL for the best possible result", with: "https://www.gov.uk/"

    # Allows the user to give comments
    fill_in "Your comments about these results", with: "Looking good!"

    click_on "Submit feedback"

    expect(bigquery_table).to have_received(:insert).with(
      hash_including(
        {
          comments: "Looking good!",
          suggested_url: "https://www.gov.uk/",
        },
      ),
    )
  end

  scenario "submitting feedback with an invalid suggested URL fails but doesn't lose input" do
    perform_search

    fill_in "URL for the best possible result", with: "bad url"
    within(all(".search-results__ranking")[1]) { choose "Good" }
    click_on "Submit feedback"

    # Doesn't send the data to Bigquery
    expect(bigquery_table).not_to have_received(:insert)

    # Shows an error message
    expect(page).to have_content("URL for the best possible result must be a valid URL")

    # Doesn't lose the input
    within(all(".search-results__ranking")[1]) do
      expect(page).to have_checked_field("Good")
    end
    expect(page).to have_field("URL for the best possible result", with: "bad url")
  end

  scenario "submitting feedback includes user ID" do
    page.driver.browser.set_cookie("user_id=foo-bar")

    perform_search
    click_on "Submit feedback"

    expect(bigquery_table).to have_received(:insert).with(
      hash_including(
        anonymised_user_id: "foo-bar",
      ),
    )
  end

  scenario "visiting without cookies generates a user ID cookie on first visit" do
    page.driver.browser.clear_cookies
    visit "/"

    perform_search
    click_on "Submit feedback"

    expect(bigquery_table).to have_received(:insert).with(
      hash_including(
        anonymised_user_id: a_string_matching(/\A[a-f0-9-]{36}\z/),
      ),
    )
  end

  def perform_search
    visit "/"
    fill_in "Search GOV.UK using the new search engine", with: "government digital service"
    click_on "Search"
  end
end
