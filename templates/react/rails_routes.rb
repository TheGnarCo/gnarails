Rails.application.routes.draw do
  root to: "home#default"

  get "/*path", to: "home#default"
end
