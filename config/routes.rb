# encoding: utf-8

Abikantenstadl::Application.routes.draw do
  controller :static do
    root :action => :index
  end
  
  get "login" => "sessions#new", :as => :login
  post "login" => "sessions#create"
  get "logout" => "sessions#destroy", :as => :logout
  
  scope :path_names => { :new => "neu", :edit => "bearbeiten" } do
    
    scope :controller => :users, :path => "konto" do
      get "activate", :path => "aktivieren", :as => :activate_user
      put "finish_activation"
      get "forgot_password", :path => "passwort_vergessen"
      post "reset_password"
      get :edit_own, :path => "bearbeiten"
      put :action => :update
    end
  
    resources :users, :path => Rack::Utils.escape("schüler"), except: [:show] do
      member do
        post :reset
      end
    end
    
    controller :profiles, :path => "steckbrief" do
      root :action => :index, :as => :profiles
      get "(/:id)/bearbeiten", :action => :edit, :as => :edit_profile
      put "(/:id)", :action => :update, :as => :profile
    end
    
    controller :about, :path => Rack::Utils.escape("über-uns"), :as => :about do
      root :action => :index, :as => ""
      scope :path => ":user" do
        get :action => :show_user, :as => :user
        post :action => :create
        scope :path => ":entry", :as => :entry do
          get "bearbeiten", :action => :edit, :as => :edit
          put :action => :update
          delete :action => :destroy
        end
      end
    end
    
    resources :photos, :path => "fotos", only: [:index, :create, :destroy]
    
  end
end
