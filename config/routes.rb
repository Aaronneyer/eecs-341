Eecs341::Application.routes.draw do
  resources :players_years

  resources :games

  resources :teams

  resources :players do
    collection do
      get :search
      get :results
    end
  end
  
  root to: "home#home"

end
