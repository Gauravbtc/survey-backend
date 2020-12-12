Rails.application.routes.draw do
  #devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get 'login_user' ,to: 'api_base#login_user'

      devise_for :users , controllers: { sessions: 'api/v1/users/sessions',
                                         registrations: 'api/v1/users/registrations'
                                        }
       resources :surveys
       resources :participants, only: [:create] do
        collection do
          post "create_survey_result"
          post "show_survey_result"
          get "verify_survey_auth"
          post "survey_questions"
        end
       end
    end
  end
end
