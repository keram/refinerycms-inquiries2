module Refinery
  module Admin
    module Inquiries
      module InquiriesHelper

        def inbox_count
          @inbox_count ||= Refinery::Inquiries::Inquiry.fresh.ham.count
        end

        def spam_count
          @spam_count ||= Refinery::Inquiries::Inquiry.spam.count
        end

        def archived_count
          @archived_count ||= Refinery::Inquiries::Inquiry.archived.count
        end
      end
    end
  end
end
