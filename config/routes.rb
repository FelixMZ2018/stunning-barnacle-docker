Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get 'status', to: 'app#status'
      get 'messages/index', to: 'messages#index'
      post 'messages/create', to: 'messages#create'
      get 'messages/show/:id', to: 'messages#show'
      put 'messages/edit/:id', to: 'messages#update'
      delete 'messages/destroy/:id', to: 'messages#destroy'
      
    end
end
end
