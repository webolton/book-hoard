# frozen_string_literal: true

Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check
  root 'dashboard#index'

  resources :authors do
    collection do
      get 'new_modal'
    end
  end

  resources :entries
end
