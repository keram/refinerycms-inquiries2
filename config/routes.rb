plugin = Refinery::Plugins['inquiries']
if plugin
  Refinery::Core::Engine.routes.draw do
    # Frontend routes
    if plugin.page.present? && Refinery::Pages.marketable_urls
      Globalize.with_locales plugin.page.translated_locales do |locale|
        get plugin.page.nested_path,
          to: 'inquiries/inquiries#new',
          as: "new_inquiries_inquiry_#{locale}"
        post plugin.page.nested_path,
          to: 'inquiries/inquiries#create',
          as: "inquiries_inquiries_#{locale}"
      end
    else
      namespace :inquiries do
        resources :inquiries, path: '', only: [:index, :new, :create] do
          collection do
            get :thank_you
          end
        end
      end
    end

    # Admin routes
    namespace :admin, path: Refinery::Core.backend_route do
      namespace :inquiries do
        resources :inquiries, only: [:index, :show, :destroy] do
          collection do
            get :spam
            get :archived
          end
          member do
            get :toggle_spam
            get :toggle_archived
          end
        end
        resources :settings, only: [:edit, :update]
      end
    end
  end
end
