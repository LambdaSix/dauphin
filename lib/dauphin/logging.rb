module Dauphin
  module Logging
    class << self
      attr_accessor :logger, :file

      def logger
        @logger ||= StdoutLogger
      end

      def file
        pathname = Dauphin.root
        @file ||= pathname.join 'log', 'prince.log'
      end
    end
  end
end