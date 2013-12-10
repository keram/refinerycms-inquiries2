module Refinery
  module Inquiries
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::Inquiries

      engine_name :refinery_inquiries

      initializer 'register inquiries plugin' do
        Refinery::Plugin.register do |plugin|
          plugin.name = 'inquiries'
          plugin.url = proc {
            Refinery::Core::Engine.routes.url_helpers.admin_inquiries_inquiries_path
          }
          plugin.pathname = root
          plugin.activity = {
            class_name: :'refinery/inquiries/inquiry',
            url_prefix: ''
          }
        end
      end

      initializer 'reload routes', after: :set_routes_reloader_hook do
        Rails.application.routes_reloader.reload!
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Inquiries)
      end
    end
  end
end
