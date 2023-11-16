Rails.application.routes.draw do
  mount GovukPublishingComponents::Engine, at: "/component-guide" if Rails.env.development?

  # Defines the root path route ("/")
  # root "posts#index"
end
