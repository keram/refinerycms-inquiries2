module Refinery
  module Admin
    module Inquiries
      class InquiriesController < Refinery::AdminController

        crudify :'refinery/inquiries/inquiry',
                order: 'id ASC'

        def index
          @inquiries = find_all_inquiries.fresh.ham
          @grouped_inquiries = group_by_date(@inquiries)
        end

        def spam
          @inquiries = find_all_inquiries.spam

          @grouped_inquiries = group_by_date(@inquiries)

          render action: :index
        end

        def toggle_spam
          find_inquiry
          @inquiry.toggle!(:spam)

          redirect_to :back
        end

        def archived
          @inquiries = find_all_inquiries.archived

          @grouped_inquiries = group_by_date(@inquiries)

          render action: :index
        end

        def toggle_archived
          find_inquiry
          @inquiry.toggle!(:archived)

          redirect_to :back
        end

        protected

        def record_actions_template
          @record_actions_template ||= action
        end
      end
    end
  end
end
