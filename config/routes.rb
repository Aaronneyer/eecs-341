Eecs341::Application.routes.draw do
  resources :players_years

  resources :games

  resources :teams do
    collection do
      get :search
      get :results
    end
    member do
      get :games
    end
  end

  resources :players do
    collection do
      get :search
      get :results
      get :playallgames
    end
    member do
      get :games
    end
  end

  root to: "home#home"

end
