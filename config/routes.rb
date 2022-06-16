Rails.application.routes.draw do
  root "timer#index"
  get "/time", to: "timer#time"
end
