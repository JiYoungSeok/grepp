Rails.application.routes.draw do
  
	root 'sales#index'
	get '/sales/:update_at', 	to: 'sales#show', 	as: 'detail_daily_revenue'
	resource :sales, only: [:index]
	resource :courses, only: [:new, :create, :index, :show]

  	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
