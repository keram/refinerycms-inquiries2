module Refinery
  module Inquiries
    class ConfirmationEmailSetting

      include ActiveModel::Validations
      include ActiveModel::Conversion
      extend ActiveModel::Naming

      def self.attr_accessor(*vars)
        @attributes ||= []
        @attributes.concat( vars )
        super
      end

      def self.attributes
        @attributes
      end

      def initialize(attributes={})
        attributes && attributes.each do |name, value|
          send("#{name}=", value) if respond_to? name.to_sym
        end
      end

      def name
        'confirmation_email'
      end

      def slug
        name
      end

      def self.inspect
        "#<#{ self.to_s} #{ self.attributes.collect{ |e| ":#{ e }" }.join(', ') }>"
      end

      def persisted?
        true
      end

      def new_record?
        !persisted?
      end

      def restricted?
        Refinery::Setting.where(
            name: ["confirmation_email_body_#{Globalize.locale}",
                    "confirmation_email_subject_#{Globalize.locale}"],
            scoping: 'inquiries',
            restricted: true
          ).any?
      end

      def update_attributes(attrs)
        attrs[:confirmation_email].each do |key, val|
          setting = Refinery::Setting.find_by(
            name: "confirmation_email_#{key}_#{Globalize.locale}",
            scoping: 'inquiries'
          )

          setting.update_attributes(value: val.to_s)
          setting.errors[:value].each do |error|
            errors[key] << error
          end if setting.errors.any?
        end

        !errors.any?
      end

    end
  end
end
