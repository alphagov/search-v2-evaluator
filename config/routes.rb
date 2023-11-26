Rails.application.routes.draw do
  mount GovukPublishingComponents::Engine, at: "/component-guide" if Rails.env.development?

  # Healthchecks
  get "/healthcheck/live", to: proc { [200, {}, %w[OK]] }
  get "/healthcheck/ready", to: GovukHealthcheck.rack_response

  resource :search, only: %i[show]
  resource :feedbacks, only: %i[create]

  get "/how-to-rate", to: "pages#how_to_rate", as: :how_to_rate

  root "searches#show"
end
