Rails.application.routes.draw do
  
	root 'sales#index'
	get '/sales/:update_at', to: 'sales#show', 	as: 'detail_daily_revenue'
	resources :courses, only: [:new, :create, :index, :show]
	resources :sales, only: [:index]
end
