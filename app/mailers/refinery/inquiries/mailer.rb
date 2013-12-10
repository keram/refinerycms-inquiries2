module Refinery
  module Inquiries
    class Mailer < ActionMailer::Base

      def confirmation(inquiry)
        @inquiry = inquiry
        mail subject:   Refinery::Inquiries::Setting.confirmation_subject,
             to:        inquiry.email,
             from:      "#{Refinery::Core.site_name} <#{Refinery::Core.site_emails_emitter}>",
             reply_to:  Refinery::Inquiries::Setting.notification_recipients.split(',').first
      end

      def notification(inquiry)
        @inquiry = inquiry
        mail subject:   Refinery::Inquiries::Setting.notification_subject,
             to:        Refinery::Inquiries::Setting.notification_recipients,
             from:      "#{Refinery::Core.site_name} <#{Refinery::Core.site_emails_emitter}>",
             reply_to:  inquiry.email
      end

    end
  end
end
