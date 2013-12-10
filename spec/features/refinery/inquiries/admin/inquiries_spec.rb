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
                page.should have_content("You have not received any inquiries yet.")
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
              page.should have_selector("a[href='/#{Refinery::Core.backend_route}/inquiries']")
              page.should have_content("Spam")
              page.should have_selector("a[href='/#{Refinery::Core.backend_route}/inquiries/spam']")
              page.should have_content("Update who gets notified")
              page.should have_selector("a[href*='/#{Refinery::Core.backend_route}/inquiries/settings/inquiry_notification_recipients/edit']")
              page.should have_content("Edit confirmation email")
              page.should have_selector("a[href*='/#{Refinery::Core.backend_route}/inquiries/settings/confirmation_email']")
            end
          end
        end

        describe "index" do
          it "shows inquiry list" do
            visit refinery.admin_inquiries_inquiries_path

            within "#content" do
              page.should have_content("David Jones said Hello, I really like your website. Was it hard to build a...")
            end
          end
        end

        describe "show" do
          it "shows inquiry details" do
            visit refinery.admin_inquiries_inquiries_path

            within "#inquiry_#{inquiry.id}" do
              click_link "Read the inquiry"
            end

            page.should have_content("From David Jones [dave@refinerycms.com]")
            page.should have_content("Hello, I really like your website. Was it hard to build and maintain or could anyone do it?")
            within "#actions" do
              page.should have_content("Back to all Inquiries")
              page.should have_selector("a[href='/#{Refinery::Core.backend_route}/inquiries']")
              page.should have_content("Archive")
              page.should have_selector("a[href='/#{Refinery::Core.backend_route}/inquiries/#{inquiry.id}/toggle_archive']")
              page.should have_content("Mark as spam")
              page.should have_selector("a[href='/#{Refinery::Core.backend_route}/inquiries/#{inquiry.id}/toggle_spam']")
              page.should have_content("Remove this inquiry forever")
              page.should have_selector("a[href='/#{Refinery::Core.backend_route}/inquiries/#{inquiry.id}']")
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
              page.should have_content("David Jones said Hello, I really like your website. Was it hard to build a...")
            end
          end
        end

        describe "update who gets notified" do
          it "sets receiver" do
            visit refinery.admin_inquiries_inquiries_path

            click_link "Update who gets notified"
            within ".edit_setting" do
              fill_in "setting_value", with: "phil@refinerycms.com"
              click_button "Save"
            end

            within "#main" do
              page.should have_content("Setting 'Inquiry Notification Recipients' was successfully updated.")
            end
          end
        end

        describe "updating confirmation email copy" do
          it "sets message" do
            visit refinery.admin_inquiries_inquiries_path

            click_link "Edit confirmation email"

            within ".edit_setting" do
              fill_in "subject__en", with: "subject"
              fill_in "body__en", with: "message"
              click_button "Save"
            end

            within "#main" do
              page.should have_content("Inquiry 'confirmation email' was successfully updated.")
            end
          end
        end

      end
    end
  end
end
