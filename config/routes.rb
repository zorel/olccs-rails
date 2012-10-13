require 'sidekiq/web'

Olccs::Application.routes.draw do

  root :to => 'welcome#index'

  match '/post.php' => 'welcome#postphp', :via => :post
  match '/backend.php' => 'welcome#backendphp', :via => :get
  match '/totoz.php' => 'welcome#totozphp', :via => :get
  match '/urls(.:format)' => 'welcome#urls', :via => :get
  
  match '/t(/:tribune(/:action))(.:format)' => 'tribune', :as => 'tribune'

  match '/auth/:provider/callback', :to => 'sessions#create'
  match '/session/destroy', :to => 'sessions#destroy', :as => 'signout'

  match '/u' => 'user#index', :as => :user
  match '/u/save_olcc_cookie' => 'user#save_olcc_cookie', :as => :save_olcc_cookie
  match '/u/reload_olcc_cookie' => 'user#reload_olcc_cookie', :as => :reload_olcc_cookie
  match '/u(/:action(.:format))' => 'user'

  match '/about' => 'welcome#about'
  match '/help' => 'welcome#help'
  match '/api' => 'welcome#api'
  match '/boards.xml' => 'welcome#boards'

  #match ':controller(/:action(/:id))(.:format)'

  mount Sidekiq::Web => '/sidekiq'
end
