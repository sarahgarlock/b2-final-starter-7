Rails.application.routes.draw do
  resources :merchants, only: [:show] do
    resources :dashboard, only: [:index]
    resources :items, except: [:destroy]
    resources :item_status, only: [:update]
    resources :invoices, only: [:index, :show, :update]
    resources :coupons, only: [:index, :new, :show, :update, :create]
  end

  namespace :admin do
    resources :dashboard, only: [:index]
    resources :merchants, except: [:destroy]
    resources :merchant_status, only: [:update]
    resources :invoices, except: [:new, :destroy]
  end
  post "/merchants/:id/coupons/new", to: "coupons#create"
  post "/merchants/:id/coupons/:id", to: "coupons#update"
end
