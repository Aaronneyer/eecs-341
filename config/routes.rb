Eecs341::Application.routes.draw do
  resources :players_years

  resources :plays

  resources :games

  resources :teams

  resources :players

end
