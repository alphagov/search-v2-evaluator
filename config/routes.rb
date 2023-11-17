Rails.application.routes.draw do
  mount GovukPublishingComponents::Engine, at: "/component-guide" if Rails.env.development?

  resource :search, only: %i[show]
  resource :feedback, only: %i[create]

  root "searches#show"
end
