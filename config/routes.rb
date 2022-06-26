# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope "(:locale)", defaults: {locale: I18n.default_locale} do
    get "index", to: "index#index"

    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    get "logout", to: "sessions#destroy"
  end

  root to: "index#index"
end
