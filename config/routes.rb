Rails.application.routes.draw do
  scope "(:locale)", locale: /en|ru/ do
    resources :game_sessions do
      resources :quests, only: [ :create, :show ] do
        member do
          patch :submit
          delete :discard
        end
      end
    end
    post "game_sessions/:id/join", to: "game_sessions#join", as: :join_game_session # TODO: put inside game_sessions block
    delete "game_sessions/:id/leave", to: "game_sessions#leave", as: :leave_game_session

    resources :players
    post "players/:id/login", to: "players#login", as: :login_player
    delete "logout", to: "players#logout", as: :logout_player
    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

    # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
    # Can be used by load balancers and uptime monitors to verify that the app is live.
    get "up" => "rails/health#show", as: :rails_health_check

    # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
    # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
    # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

    # Defines the root path route ("/")
    root to: redirect("/#{I18n.locale}/players")
  end
end
