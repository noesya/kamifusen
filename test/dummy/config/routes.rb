Rails.application.routes.draw do
  resources :samples
  get 'before' => 'samples#before'
  get 'after' => 'samples#after'
  root to: 'samples#index'
end
