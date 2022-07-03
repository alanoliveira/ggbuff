# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "login", to: "sessions#new"
  get "choose_aime", to: "sessions#choose_aime"
  post "login", to: "sessions#create"
  get "logout", to: "sessions#destroy"

  get "matches", to: "player#matches"
  get "load_matches", to: "player#load_matches"

  root to: "player#matches"
end
