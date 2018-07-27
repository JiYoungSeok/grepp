Rails.application.routes.draw do
  
	root 'courses#index'
	resource :courses, only: [:new, :create, :index, :show]
  	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
