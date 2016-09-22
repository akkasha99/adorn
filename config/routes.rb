Rails.application.routes.draw do
  #devise_for :users
  get "/home" => "home#index"
  get "/jojo" => "home#jojo"
  get "/admin" => "admin/admins#index"
  get "/admin/dashboard" => "admin/admins#dashboard"
  get "/user" => "user/users#index"
  get "/newsfeed" => "user/users#news_feed"
  get "/forget/password/:id/:token" => "user/users#edit_pass"
  get "/terms" => "home#terms_of_services"
  get "/policy" => "home#privacy_policy"
  get "/user/profile" => "desktop/users#profile"
  get "/privacy_policy" => "desktop/users#privacy_policy"
  get "/support" => "desktop/users#privacy_policy"
  get "/faq" => "desktop/users#privacy_policy"

  #get "/featured_brands/:id" => "home#featured_brands"
  #get "/featured_bloggers/:id" => "home#featured_bloggers"
  #get "/user/outfit/comment/:id" => "user/user_outfits#comments"
  #get "/user/item/comment/:id" => "user/user_items#comments"
  #get "/user/blog/comment/:id" => "user/user_blogs#comments"

  root :to => 'home#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  devise_for :users, :controllers => {
      :sessions => "users/sessions",
      :confirmations => "users/confirmations",
      :passwords => "users/passwords",
      :registrations => "users/registrations",
      :omniauth_callbacks => "users/omniauth_callbacks",
      #      :confirmations => "users/confirmations"
  }
  devise_scope :user do
    #    get 'sign_in', :to => 'users/sessions#new', :as => :new_session
    #    get "sign_out", :to => "users/sessions#destroy"
    #    get "sign_up", :to => "users/registrations#new"
    get "/users/sign_out_mobile" => "users/sessions#destroy_mobile"
  end
  resources :home do
    collection do
      get 'fav_brands'
      get 'fav_bloggers'
      get 'jojo_search'
    end
  end

  namespace :admin do
    resources :admins do
      collection do
      end
    end

    resources :users do
      collection do
        get 'new'
        post 'create'
        get 'edit'
        post 'update'
        get 'delete'
        get 'activate_deactivate_user'
        get 'reported_users'
        get 'reported_items'
        get 'reported_outfits'
        get 'reported_blogs'
        get 'report_update'
        get 'user_name_present'
        get 'user_email_present'
      end
    end

    resources :brands do
      collection do
        get 'new'
        post 'create'
        get 'edit'
        post 'update'
        get 'delete'
      end
    end

    resources :basic_categories do
      collection do
        get 'new'
        post 'create'
        get 'edit'
        post 'update'
        get 'delete'
      end
    end

    resources :basic_subcategories do
      collection do
        get 'new'
        get 'new_subcategory'
        post 'create'
        get 'edit'
        post 'update'
        get 'delete'
      end
    end

    resources :basic_items do
      collection do
        get 'new'
        get 'new_item'
        post 'create'
        get 'edit'
        post 'update'
        get 'delete'
        get 'basic_categories'
      end
    end

    resources :user_items do
      collection do
        get 'get_user_items'
        get 'change_item_control'
      end
    end

    resources :user_blogs do
      collection do
        get 'new'
        post 'create'
        get 'edit'
        post 'update'
        get 'get_user_blogs'
        get 'change_blog_control'
        get 'block_unblock_feed'
        get 'block_unblock_blog'
        get 'is_featured'
        get 'bloggers_detail'
        get 'all_bloggers'
      end
    end

    resources :user_outfits do
      collection do
        get 'get_outfits'
        post 'create'
        get 'outfit_activity'
      end
    end
  end
  namespace :desktop do
    resources :desktop do
      collection do
        get 'index'
        get 'item'
        get 'outfit'
        get 'closet'
        get 'profile'
        get 'landing'
      end
    end

    resources :users do
      collection do
        post 'profile_update'
      end
    end
  end

  namespace :user do
    resources :users do
      collection do
        get 'check_email'
        get 'check_email_admin'
        get 'check_username'
        get 'add_adoorn'
        get 'search_users'
        get 'authenticate_password'
        get 'goto_profile_pic'
        get 'goto_profile'
        get 'goto_aboutme'
        get 'goto_password'
        get 'goto_location'
        get 'linked_accounts'
        get 'goto_notification'
        get 'back_to_setting'
        get 'user_adoorned'
        post 'picture_update'
        post 'picture_update_android'
        patch 'aboutme_update'
        patch 'password_update'
        get 'location_update'
        patch 'profile_update'
        get 'notifications_update'
        get 'static_pages'
        get 'newsfeed_partial'
        get 'search_partial'
        get 'user_closet'
        get 'adoorners'
        get 'adoornings'
        get 'mentions'
        get 'profile'
        get 'update_newsfeed'
        get 'searching'
        get 'desk_search'
        get 'media_detail'
        get 'unlink_account'
        get 'edit_pass'
        get 'reporting'
        get 'y_reporting'
        get 'feedback'
        get 'user_name_check'
        get 'user_email_check'
        get 'desk_reporting'
      end
    end

    resources :user_items do
      collection do
        get 'user_items_list'
        get 'show'
        get 'upload_item'
        get 'comments'
        post 'create'
        post 'add_comments'
        get 'edit_item'
        post 'update_item'
        get 'feed_adoorning'
        get 'item_details'
        get 'upc_details'
        post 'add_item_pic'
        get 'comments'
        get 'item_private'
        get 'read_image'
        get 'item_delete'
        post 'android_image_up'
        get 'open_search'
        get 'search_items'
        get 'sementic_result'
        get 'search_more'
        get 'add_to_closet'
      end
    end

    resources :user_outfits do
      collection do
        post 'create_outfit'
        get 'user_outfits_list'
        get 'show'
        get 'new_outfit'
        get 'upload'
        get 'items_list'
        post 'save_outfit'
        get 'edit_outfit'
        post 'update_outfit'
        get 'outfit_unadoorn'
        post 'add_comments'
        get 'get_item_data'
        get 'feed_adoorning'
        get 'select_basics'
        get 'select_basics_subcategories'
        get 'select_basic_items'
        get 'show_basic_item'
        get 'comments'
        get 'outfit_delete'
        #get 'add_to_closet'
      end
    end
    resources :user_blogs do
      collection do
        get 'blogs_index'
        get 'show'
        get 'blog_adoorning'
        post 'add_comments'
        get 'search_blogs'
        get 'i_adoor'
        get 'we_adoor'
        get 'search_user_blogs'
        get 'complete_search'
        get 'blogs_list'
        get 'comments'
        get 'blogger_blogs'
        get 'blogger_adoorn'
      end
    end

  end
  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
