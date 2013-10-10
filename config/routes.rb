resources :projects, only: [] do
  resources :issue_ratio_graphs, only: [], on: :member do
    get :data, on: :collection
  end
end
