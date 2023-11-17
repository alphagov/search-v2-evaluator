Rails.application.routes.draw do
  mount GovukPublishingComponents::Engine, at: "/component-guide" if Rails.env.development?

  resource :search, only: %i[show]
  resource :feedback, only: %i[create]

  get "/how-to-rate", to: "pages#how_to_rate", as: :how_to_rate

  root "searches#show"
end
