Rails.application.routes.draw do
  # get "/", to: "login#new"
  get "/login", to: "login#new"
  post "/login", to: "login#create"
  delete "/login", to: "login#destroy", as: "logout"

  get  "/orders/new", to: "orders#new", as: "new_order"
  post "/orders",     to: "orders#create", as: "orders"
  post "/sale",     to: "sale#create", as: "sale"
  get "/sale", to: "sale#index", as: "index_sale"
  # 新規登録画面、修正画面のルート
  get "/sale/new", to: "sale#new", as: "new_sale"
  get "/sale/edit", to: "sale#edit", as: "edit_sale"
  # ★ 受注削除用のルートを追加
  delete "/sale/:juchuno", to: "sale#destroy", as: "destroy_sale"
  get "/products/search", to: "products#search"
  get "/products/search_by_hinban", to: "products#search_by_hinban"

  resources :delivery_addresses, only: [ :index ] do
    collection do
      get :search_address
    end
  end

  resources :sale do
    collection do
      post :save_draft_and_redirect # 明細をセッションに一時保持して配送先画面へ
      get  :delivery_input          # 配送先入力画面
      post :apply_delivery          # 選択した配送先をセッションに反映して受注画面へ戻る
    end
  end

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
