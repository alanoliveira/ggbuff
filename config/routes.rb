# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "login", to: "sessions#new"
  get "choose_aime", to: "sessions#choose_aime"
  post "login", to: "sessions#create"
  get "logout", to: "sessions#destroy"

  get "matches", to: "matches#index"

  get "load_player", to: "data_loader#load_player"
  get "load_matches", to: "data_loader#load_matches"

  root to: "matches#index"
end
