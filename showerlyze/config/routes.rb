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


  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  # Called by Pi to create new shower
  post '/bathroom/:bathroom_id/shower/create' => 'showers#create', as: :create_shower
  post '/shower/:shower_id/data_point/create' => 'data_points#create', as: :create_data_point

  get '/houses/:house_id/showers/last_week.json' => 'showers#last_week'
  get '/houses/:house_id/showers/pie_chart_data.json' => 'showers#pie_chart_data'

  get '/api/users/:id/percent_consumption.json' => 'users#percent_consumption'
  get '/api/users/:id/shower_data.json' => 'users#shower_data'
  get '/api/showers/by_user.json' => 'showers#by_user'
  get '/api/showers/:id/data.json' => 'showers#data'
  get '/api/showers/last_data.json' => 'showers#last_shower_data'

end
