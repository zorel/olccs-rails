require 'sidekiq/web'

Olccs::Application.routes.draw do

  root :to => 'welcome#index'

  match '/post.php' => 'welcome#postphp', :via => :post
  match '/backend.php' => 'welcome#backendphp', :via => :get
  match '/totoz.php' => 'welcome#totozphp', :via => :get
  
  match '/t(/:tribune(/:action))(.:format)' => 'tribune'

  match '/auth/:provider/callback', :to => 'sessions#create'
  match '/session/destroy', :to => 'sessions#destroy', :as => 'signout'

  match '/u(/:action)(.:format)' => 'user'

  match ':controller(/:action(/:id))(.:format)'

  mount Sidekiq::Web => '/sidekiq'
end
