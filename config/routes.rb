# frozen_string_literal: true

Rails.application.routes.draw do
  # Defines the root path route ("/")
  root 'home#index'

  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :categories
  resources :spendings
end
