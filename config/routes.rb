Rails.application.routes.draw do
  mount GovukPublishingComponents::Engine, at: "/component-guide" if Rails.env.development?

  resource :search, only: %i[show]

  root "searches#show"
end
