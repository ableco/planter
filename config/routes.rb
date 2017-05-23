Planter::Engine.routes.draw do
  root "plants#index"
  resources :plants, param: :issue_number, only: [:index] do
    get :seed
    get :deseed

    collection do
      get :reset
    end
  end
end
