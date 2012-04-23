ManybotsFoursquare::Engine.routes.draw do
  resources :foursquare do
    collection do
      get 'callback'
    end
    member do
      post 'toggle'
    end
  end
  
  root to: 'foursquare#index'
end
