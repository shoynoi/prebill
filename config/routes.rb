# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "home#index"
  resources :services, only: %i(new create edit update destroy)
end
