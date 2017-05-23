Planter::Engine.routes.draw do
  root "plants#index"
  resources :plants, param: :issue_number, only: [:index] do
    get :seed
  end
end
