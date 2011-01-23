Listolicious::Application.routes.draw do
  resources :shares, :only => [:create]

  match '/auth/:provider/callback' => 'authentications#create'
  match '/auth/failure' => 'authentications#failure'
  
  #resources :authentications

  resources :lists, :except => [:index, :new]

  resources :list_items, :only => [:create, :update, :destroy]

  #resources :activities

  devise_for :users, :controllers => { :registrations => 'registrations' } do
    get "registrations/new_from_fb", :to => "registrations#new_from_fb", :as => "new_registration_from_fb"
  end
  
  resources :users, :only => [] do
    resources :lists, :only => [:index]
  end

  root :to => "application#home"
  
end
