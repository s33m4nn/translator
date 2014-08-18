Translator::Engine.routes.draw do
  resources :translations do
    collection do
      get :export
      post :import
    end
  end
end
