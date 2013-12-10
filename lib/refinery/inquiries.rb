require 'refinerycms-core'
require 'refinerycms-settings'

module Refinery
  autoload :InquiriesGenerator, 'generators/refinery/inquiries/inquiries_generator'

  module Inquiries
    require 'refinery/inquiries/engine'
    require 'refinery/inquiries/configuration'

    autoload :Version, 'refinery/inquiries/version'

    class << self
      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end
    end
  end
end
