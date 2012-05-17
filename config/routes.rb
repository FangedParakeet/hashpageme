Hashpageme::Application.routes.draw do

  resources :hpage
  
  root :to => "hpage#index"
  
  match "/auth/twitter/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout
  
  get '/:id' => "hpage#show"
end
