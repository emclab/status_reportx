StatusReportx::Engine.routes.draw do

  resources :reports do
    collection do
      get :search
      put :search_results
    end
  end
  
  root :to => 'reports#index'
end
