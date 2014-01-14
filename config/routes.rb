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
      patch "finish_activation"
      get "forgot_password", :path => "passwort_vergessen"
      post "reset_password"
      get :edit_own, :path => "bearbeiten"
      patch :action => :update
    end
  
    resources :users, :path => "schüler", except: [:show] do
      member do
        post :reset
      end
    end
    
    controller :profiles, :path => "steckbrief" do
      get "/", :action => :index, :as => :profiles
      get "(/:id)/bearbeiten", :action => :edit, :as => :edit_profile
      patch "(/:id)", :action => :update, :as => :profile
    end
    
    controller :about, :path => "über-uns", :as => :about do
      get "/", :action => :index, :as => ""
      scope :path => ":user" do
        get :action => :show_user, :as => :user
        post :action => :create
        scope :path => ":entry", :as => :entry do
          get "bearbeiten", :action => :edit, :as => :edit
          patch :action => :update
          delete :action => :destroy
        end
      end
    end
    
    resources :photos, :path => "fotos", only: [:index, :create, :destroy]
    
    { rumors: "gerüchte", quotes: "zitate", survival_tips: "survivaltips", short_stories: "shortstories" }.each do |section, path|
      resources section, :controller => :snippets, :path => path, :except => [:show, :new], :defaults => { :section => section }
    end
    
    resources :polls, :path => "umfragen", except: [:show] do
      collection do
        get :results
      end
      member do
        post :vote
      end
    end
    
    resources :stories, :path => "kursberichte", except: [:show, :new]
    
  end
end
