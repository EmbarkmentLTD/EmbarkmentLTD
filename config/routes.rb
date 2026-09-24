Rails.application.routes.draw do
  devise_for :users, path: "", path_names: {
    sign_in: "login",
    sign_out: "logout",
    registration: "register"
  }, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords"
  }

  root "home#index"

  # Kamal and external probes may use HEAD on /up during rollout checks.
  match "/up", to: "rails/health#show", via: [ :get, :head ], as: :rails_health_check

  # Footer routes

  resources :products do
    collection do
      get :search
      get :my_products
    end
    member do
      get :quotation
      post :toggle_availability  # Add this line
    end
    resources :reviews, only: [ :create, :update, :destroy ]
  end

  # Page routes
  get "contact-us", to: "home#contact_us"
  get "our-mission", to: "home#mission"
  get "about-us", to: "home#about_us"
  get "privacy-policy", to: "home#privacy_policy", as: :privacy_policy
  get "terms-and-conditions", to: "home#terms_and_conditions", as: :terms_and_conditions

  # Verification routes
  get "/verify", to: "verifications#show", as: "verification"
  post "/verify", to: "verifications#verify", as: "verify_verification"
  post "/verify/resend", to: "verifications#resend", as: "resend_verification"

  get "/sign_in_verification", to: "sign_in_verifications#show", as: "sign_in_verification"
  post "/sign_in_verification", to: "sign_in_verifications#create"
  post "/sign_in_verification/resend", to: "sign_in_verifications#resend", as: "resend_sign_in_verification"

  # SIMPLE quotation routes - no resources
  get "quotations/cart", to: "quotations#cart", as: "quotation_cart"
  post "quotations/submit_email_quotation", to: "quotations#submit_email_quotation", as: "submit_email_quotation"
  post "quotations/clear_cart", to: "quotations#clear_cart", as: "clear_quotation_cart"
  post "quotations/mark_requested_via", to: "quotations#mark_requested_via", as: "mark_quotation_requested_via"
  delete "quotations/remove_quotation_item/:product_id", to: "quotations#remove_quotation_item", as: "remove_quotation_item"

  # User routes
  resources :users, only: [ :show, :edit, :update ]

  resources :quotation_requests, only: [ :index, :show ]

  # Profile routes
  get "/profile", to: "users#profile"
  get "/my_products", to: "products#my_products"

  # Support Chat Routes
  post "/support_chat_messages", to: "support_chat_messages#create"
  get "/support_chat_messages/conversations/:id(.json)", to: "support_chat_messages#conversations", as: "support_chat_conversation", format: "json"
  get "/support_chat_messages/unread_counts(.json)", to: "support_chat_messages#unread_counts", as: "support_chat_unread_counts", format: "json"

  # Support Dashboard Routes - FIXED: Remove namespace and use simple routes
  get "/support/dashboard", to: "support_dashboard#index", as: "support_dashboard"
  get "/support/conversations/:id", to: "support_dashboard#conversations", as: "support_conversations"
  post "/support/create_message", to: "support_dashboard#create_message", as: "support_create_message"
  post "/support/chat_access_requests/:id/approve", to: "support_dashboard#approve_chat_access_request", as: "approve_support_chat_access_request"

  # Attachment routes
  get "attachments/:id/purge", to: "attachments#purge", as: "purge_attachment"

  # Admin namespace routes
  namespace :admin do
    get "/dashboard", to: "dashboard#index"
    get "/dashboard/charts", to: "dashboard#charts"
    get "dashboard/verification_stats", to: "dashboard#verification_stats" # Add this line
    resources :users, only: [ :index, :new, :show, :create, :edit, :update, :destroy ]
    resources :products, only: [ :index, :show, :new, :create, :edit, :update, :destroy ]
    resources :quotation_requests, only: [ :index, :show ]
    resources :reviews, only: [ :index, :show, :edit, :update, :destroy ]  # Review management
    resources :pages, only: [ :edit, :update ]
  end
end
