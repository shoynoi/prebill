# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "home#index"
  resources :services, only: %i(new create edit update destroy)
  resource :my_account, only: %i(edit update destroy), controller: "my_account" do
    get "close" => "my_account#close"
  end
  resources :password_resets, only: %i(new create edit update)
  namespace :api do
    resources :notifications, only: %i(index update)
    resources :preset_services, only: %i(index)
  end

  get "signup" => "users#new"
  post "signup" => "users#create"
  get "login" => "user_sessions#new"
  post "login" => "user_sessions#create"
  delete "logout" => "user_sessions#destroy"
  get "tos" => "welcome#tos"
  get "policy" => "welcome#policy"
end
