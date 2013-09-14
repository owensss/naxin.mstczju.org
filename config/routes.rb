NaxinMstczjuOrg::Application.routes.draw do
  resources :forms, only: [:index, :update, :create, :new, :edit] do
    collection do
      get :edit, as: 'edit_self'
      get :print, as: 'print'
    end
  end

  ActiveAdmin.routes(self)

  # puts ActiveAdmin::Devise.config
  devise_for :staffs, ActiveAdmin::Devise.config

  root :to => 'forms#new'

  match '/login' => redirect('/admin')
  match '/about', :to => 'pages#about'
  match '/play', :to => 'play#index'
  match 'play/entry', :to => 'play#entry'
  # match '/print', :to => 'forms#print'

end
