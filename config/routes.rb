Planter::Engine.routes.draw do
  get "/reset_state", to: "plants#reset"
end
