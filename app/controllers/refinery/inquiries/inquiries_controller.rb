module Refinery
  module Inquiries
    class InquiriesController < ::ApplicationController

      before_action :find_page, only: [:create, :new]

      def index
        redirect_to action: :new
      end

      def thank_you
        @page = Page.includes(:parts).find_by(plugin_page_id: 'inquiries_thank_you')
      end

      def new
        @inquiry = Inquiry.new
      end

      def create
        @inquiry = Inquiry.new(inquiry_params)

        if @inquiry.save
          begin
            Mailer.notification(@inquiry).deliver
          rescue => e
            logger.warn "There was an error delivering the inquiry notification.\n#{e.message}\n"
          end if @inquiry.ham?

          begin
            Mailer.confirmation(@inquiry).deliver
          rescue => e
            logger.warn "There was an error delivering the inquiry confirmation:\n#{e.message}\n"
          end if @inquiry.ham?

          redirect_to refinery.url_for((thank_you_page || page).url), status: :see_other
        else
          render action: :new
        end
      end

    protected

      def find_page
        @page = Page.includes(:parts).find_by(plugin_page_id: 'inquiries')
      end
      alias_method :page, :find_page

      def thank_you_page
        @thank_you_page ||= refinery_plugin.thank_you_page
      end

    private

      def inquiry_params
        params.require(:inquiry).permit(:name, :email, :phone, :message)
      end

    end
  end
end
