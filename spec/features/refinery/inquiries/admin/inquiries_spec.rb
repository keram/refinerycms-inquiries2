require "spec_helper"

module Refinery
  module Inquiries
    module Admin
      describe Inquiry do
        refinery_login_with :refinery_superuser

        let!(:inquiry) do
          FactoryGirl.create(:inquiry,
            name: "David Jones",
            email: "dave@refinerycms.com",
            message: "Hello, I really like your website. Was it hard to build and maintain or could anyone do it?")
        end

        context "when no" do
          before(:each) { Refinery::Inquiries::Inquiry.destroy_all }

          context "inquiries" do
            it "shows message" do
              visit refinery.admin_inquiries_inquiries_path

              within "#content" do
                page.should have_content("You don't have any inquiries in inbox.")
              end
            end
          end

          context "spam inquiries" do
            it "shows message" do
              visit refinery.spam_admin_inquiries_inquiries_path

              within "#content" do
                page.should have_content("Hooray! You don't have any spam.")
              end
            end
          end
        end

        describe "action links" do
          before(:each) { visit refinery.admin_inquiries_inquiries_path }

          specify "in the side pane" do
            within "#actions" do
              page.should have_content("Inbox")
              page.should have_selector("a[href='/#{Refinery::Core.backend_route}/inquiries/inquiries']")
              page.should have_content("Archived")
              page.should have_selector("a[href='/#{Refinery::Core.backend_route}/inquiries/inquiries/archived']")
              page.should have_content("Spam")
              page.should have_selector("a[href='/#{Refinery::Core.backend_route}/inquiries/inquiries/spam']")
              page.should have_content("Update who gets notified")
              page.should have_selector("a[href*='/#{Refinery::Core.backend_route}/inquiries/settings/notification_email_recipients/edit']")
              page.should have_content("Edit confirmation email")
              page.should have_selector("a[href*='/#{Refinery::Core.backend_route}/inquiries/settings/confirmation_email']")
            end
          end
        end

        describe "index" do
          it "shows inquiry list" do
            visit refinery.admin_inquiries_inquiries_path

            within "#content" do
              page.should have_content("David Jones Hello, I really like your website. Was it hard to build and maintain or could anyone do it?")
            end
          end
        end

        describe "show" do
          it "shows inquiry details" do
            visit refinery.admin_inquiries_inquiries_path
            within "#inquiry_#{inquiry.id}" do
              click_link "Detail"
            end

            within "#content" do
              page.should have_content("David Jones")
              page.should have_content("dave@refinerycms.com")
              page.should have_content("Hello, I really like your website. Was it hard to build and maintain or could anyone do it?")
            end

            within "#actions" do
              page.should have_content("Back to all Inquiries")
              page.should have_selector("a[href='/#{Refinery::Core.backend_route}/inquiries/inquiries']")
              page.should have_content("Move to archive")
              page.should have_selector("a[href='/#{Refinery::Core.backend_route}/inquiries/inquiries/#{inquiry.id}/toggle_archived']")
              page.should have_content("Mark as spam")
              page.should have_selector("a[href='/#{Refinery::Core.backend_route}/inquiries/inquiries/#{inquiry.id}/toggle_spam']")
              page.should have_content("Delete")
              page.should have_selector("a[href='/#{Refinery::Core.backend_route}/inquiries/inquiries/#{inquiry.id}']")
            end
          end
        end

        describe "destroy" do
          before do
            Refinery::Inquiries::Inquiry.where('id != ?', inquiry.id).destroy_all
          end

          it "removes inquiry" do
            visit refinery.admin_inquiries_inquiries_path

            within "#inquiry_#{inquiry.id}" do
              click_link "Remove this inquiry forever"
            end

            within "#content" do
              page.should_not have_content(inquiry.name)
            end

            Refinery::Inquiries::Inquiry.count.should == 0
          end
        end

        describe "spam" do
          it "moves inquiry to spam" do
            visit refinery.admin_inquiries_inquiries_path


            within "#inquiry_#{inquiry.id}" do
              click_link "Mark as spam"
            end

            within "#actions" do
              page.should have_content("Spam (1)")
              click_link "Spam (1)"
            end

            within "#content" do
              page.should have_content("David Jones Hello, I really like your website.")
            end
          end
        end

        describe "update who gets notified" do

          before do
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

          it "sets receiver" do
            visit refinery.admin_inquiries_inquiries_path
            click_link "Update who gets notified"

            within ".edit_setting" do
              fill_in "setting_value", with: "phil@refinerycms.com"
              click_button "Save"
            end

            within "#main" do
              page.should have_content("Setting 'Notification recipients' was successfully updated.")
            end
          end
        end

        describe "updating confirmation email copy" do
          before do
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
          end

          it "sets message" do
            visit refinery.admin_inquiries_inquiries_path

            click_link "Edit confirmation email"

            within ".edit_confirmation_email_setting" do
              fill_in "setting_confirmation_email_subject", with: "subject"
              fill_in "setting_confirmation_email_message", with: "message"
              click_button "Save"
            end

            within "#main" do
              page.should have_content("Setting 'Confirmation email' was successfully updated.")
            end
          end
        end

      end
    end
  end
end
