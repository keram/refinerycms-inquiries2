require 'refinery/user'
require 'refinery/page'
require 'refinery/setting'

plugin = Refinery::Plugins['inquiries']
if plugin

  Refinery::User.all.each do |user|
    if user.plugins.find_by(name: plugin.name).nil?
      user.plugins.create(name: plugin.name,
                          position: (user.plugins.maximum(:position) || -1) +1)
    end
  end

  pages = {
    inquiries: {
      title: 'Contact',
      deletable: false,
      status: 'live',
      show_in_menu: true,
      plugin_page_id: plugin.name
    },
    inquiries_thank_you: {
      title: 'Thank You',
      plugin_page_id: 'inquiries_thank_you',
      deletable: false,
      status: 'live',
      show_in_menu: false,
      parent: :inquiries
    },
    inquiries_privacy_policy: {
      title: 'Privacy Policy',
      deletable: true,
      status: 'live',
      show_in_menu: false,
      plugin_page_id: 'inquiries_privacy_policy',
      parent: :inquiries
    }
  }

  Refinery::Pages::Import.new(plugin, pages, false).run

  confirmation_email = {
    subject: "Thank you for your inquiry - #{Refinery::Core.site_name}",
    message: "Hello %name%,\n\nThis email is a receipt to confirm we have received your inquiry and we'll be in touch shortly.\n\nThanks."
  }

  Refinery::I18n.frontend_locales.each do |locale|
    confirmation_email.each do |key, val|
      setting = Refinery::Setting.where(
        name: "confirmation_email_#{key}_#{locale}",
        scoping: 'inquiries',
        destroyable: false,
        restricted: true
      ).first_or_initialize

      setting.update_attributes(value: val) if setting.value.blank?
    end
  end

  notification_email = {
    recipients: Refinery::Core.site_emails_receiver,
    subject: "#{Refinery::Core.site_name} - New inquiry"
  }

  notification_email.each do |key, val|
    setting = Refinery::Setting.where(
      name: "notification_email_#{key}",
      scoping: 'inquiries',
      destroyable: false,
      restricted: true
    ).first_or_initialize

    setting.update_attributes(value: val) if setting.value.blank?
  end
end
