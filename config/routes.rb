Planter::Engine.routes.draw do
  root "plants#index"
  resources :plants, only: [:index] do
    put :reset
  end
end
