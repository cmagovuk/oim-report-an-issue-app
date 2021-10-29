Rails.application.routes.draw do
  root "report_issues#index"
  resources :report_issues, only: %i[create index]

  scope "/report_issue" do
    resources :report_issue_steps, only: %i[edit update], path_names: { edit: "" }
  end

  resource :cookies,
           path: "/about/cookies",
           path_names: { edit: "/" },
           only: %i[edit update create]

  get "report_issue/submitted", to: "report_issues#show"
  get "pages/:page", to: "pages#show"
  get "/404", to: "errors#not_found", via: :all
  get "/422", to: "errors#unprocessable_entity", via: :all
  get "/500", to: "errors#internal_server_error", via: :all
  get "/503", to: "errors#service_unavailable", via: :all
end
