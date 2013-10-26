Abikantenstadl::Application.routes.draw do
  controller :static do
    root :action => :index
  end
  
  get "login" => "sessions#new", :as => :login
  post "login" => "sessions#create"
  get "logout" => "sessions#destroy", :as => :logout
  
  resource :user, :path => "konto", :only => [:edit, :update] do
    member do
      get "activate", :path => "aktivieren"
      put "finish_activation"
      get "forgot_password", :path => "passwort_vergessen"
      post "reset_password"
    end
  end
end
