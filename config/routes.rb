Planter::Engine.routes.draw do
  resources :plants do
    get :reset
  end
end
