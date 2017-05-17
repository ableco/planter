Planter::Engine.routes.draw do
  resources :seeds, format: "html"
  resources :plants, format: "html"
end
