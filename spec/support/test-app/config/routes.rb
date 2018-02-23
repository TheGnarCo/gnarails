 Rails.application.routes.draw do
  root to: "job_postings#index"

  resources :job_postings, only: [:index]
end
