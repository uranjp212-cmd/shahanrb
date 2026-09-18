Rails.application.routes.draw do
  get "/sale", to: "sale#index", as: "index_sale"
  # root "login#new"
  # get "/", to: "login#new"
  get "/login", to: "login#new"
  post "/login", to: "login#create"
  delete "/login", to: "login#destroy", as: "logout"

  get  "/orders/new", to: "orders#new", as: "new_order"
  post "/orders",     to: "orders#create", as: "orders"
  post "/sale",     to: "sale#create", as: "sale"

  get "/products/search", to: "products#search"
  get "/products/search_by_hinban", to: "products#search_by_hinban"

  root to: "login#new"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
