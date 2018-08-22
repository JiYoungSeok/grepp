Rails.application.routes.draw do

	root 'sales#home'
   get '/sales/:site', to: 'sales#index', as: 'each_site_revenue'
	get '/sales/:site/:update_at', to: 'sales#show', as: 'detail_daily_revenue'
   get '/course/:site', to: 'courses#index', as: 'show_by_course'
	resources :courses, only: [:new, :create, :index, :show]
	resources :sales, only: [:index]
end
