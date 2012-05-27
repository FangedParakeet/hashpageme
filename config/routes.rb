Hashpageme::Application.routes.draw do

  resources :hpage
  
  root :to => "hpage#index"
  
  match "/auth/twitter/callback" => "sessions#create"
  match "/twitter/signout" => "sessions#destroy", :as => :signout
	match "/auth/failiure" => "sessions#failure"
  
  get '/:id' => "hpage#show", as: :profile
end
