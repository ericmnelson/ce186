Rails.application.routes.draw do
  resources :houses
  resources :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'users#dashboard'
  # root to: 'home#index'

  # Example resource route (maps HTTP verbs to controller actions automatically):

  post '/twilio/reply'  => 'twilio#reply', as: :twilio_reply
  get '/twilio/send_reminders/:expense_id'  => 'twilio#send_reminders', as: :twilio_send_reminders

  get '/signup' => 'users#new'
  # post '/users' => 'users#create'

  # Called by Pi to create new shower
  # post '/bathrooms/:bathroom_id/shower/create'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  get '/charges/update_status/:id' => 'charges#update_status', as: :update_charge_status

  get '/houses/:house_id/showers/last_week.json' => 'showers#last_week'
  get '/houses/:house_id/showers/pie_chart_data.json' => 'showers#pie_chart_data'

end
