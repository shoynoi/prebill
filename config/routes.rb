# frozen_string_literal: true

Rails.application.routes.draw do
  resources :services, only: %i(new create edit update destroy)
end
