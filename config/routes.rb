Eecs341::Application.routes.draw do
  resources :players_years

  resources :games

  resources :teams do
    collection do
      get :search
      get :results
      get :mostyardage
      get :teamavgforpos
      get :teamhaspmin
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
      get :averageyards
      get :yardsagainstteam
      get :recordagainstteam
      get :autocomplete_player_name
    end
    member do
      get :games
    end
  end

  root to: "home#home"

end
