Rails.application.routes.draw do
  match '/translations/:group' => "Translator::Translations#index", :as => :translations_group
  resources :translations, :to => "Translator::Translations"
end
