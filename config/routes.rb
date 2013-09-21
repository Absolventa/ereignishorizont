EventGirl::Application.routes.draw do
  root 'incoming_events#index'

  get "password_resets/new"
  get 'login' => 'sessions#new'
  get 'logout' => 'sessions#destroy'

  resources :sessions
  resources :users
  resources :password_resets
  resources :remote_sides

  resources :incoming_events

  resources :expected_events do
    resources :alarms do
      get :run, :on => :member
    end
  end

  post '/' => 'incoming_events#create'

end
