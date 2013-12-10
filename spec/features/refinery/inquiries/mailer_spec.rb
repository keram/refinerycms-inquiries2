require 'spec_helper'

module Refinery
  module Inquiries
    describe 'mailer' do
      before do
        Refinery::Inquiries::Setting.stub(:notification_recipients).and_return('rspec@refinerycms.com')
        clear_emails

        plugin = Refinery::Plugins['inquiries']
        visit plugin.page.nested_path

        fill_in 'Name', with: 'Ugis Ozols'
        fill_in 'Email', with: 'ugis.ozols@refinerycms.com'
        fill_in 'Message', with: "Hey, I'm testing!"
        click_button 'Send message'
      end

      it 'sends confirmation email' do
        open_email('ugis.ozols@refinerycms.com')

        current_email.from.should eq([Refinery::Core.site_emails_emitter])
        current_email.to.should eq(['ugis.ozols@refinerycms.com'])
        current_email.subject.should eq("Thank you for your inquiry - #{Refinery::Core.site_name}")
        current_email.body.should eq("Hello Ugis Ozols,\n\n" +
                    "This email is a receipt to confirm we have received your inquiry and we&#39;ll be in touch shortly.\n\n" +
                    "Thanks.\n")
      end

      it 'sends notification email' do
        open_email('rspec@refinerycms.com')

        current_email.from.should eq([Refinery::Core.site_emails_emitter])
        current_email.to.should eq(['rspec@refinerycms.com'])
        current_email.subject.should eq("#{Refinery::Core.site_name} - New inquiry")
        current_email.body.should eq("Hi there,\n\nYou just received a new inquiry on your website.\n\n--- inquiry starts ---\n\nName: Ugis Ozols\nEmail: ugis.ozols@refinerycms.com\nPhone: \nMessage:\n\nHey, I&#39;m testing!\n\n--- inquiry ends ---\n\nKind Regards,\nSite Name\n\nP.S. All your inquiries are stored in the \"Inquiries\" section of Refinery should you ever want to view it later there.\n")
      end
    end
  end
end
