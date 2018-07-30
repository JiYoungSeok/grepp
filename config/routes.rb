Rails.application.routes.draw do
  
	root 'sales#index'
	get '/sales/:update_at', 			to: 'sales#show', 	as: 'detail_daily_revenue'
	get '/sales/courses/:course_id',	to: 'courses#show',	as: 'detail_course'
	resource :sales, only: [:index]
	resource :courses, only: [:new, :create, :index, :show]

  	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
