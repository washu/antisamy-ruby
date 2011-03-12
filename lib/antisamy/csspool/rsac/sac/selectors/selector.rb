module RSAC
  module Selectors
    class Selector

      attr_reader :selector_type

      def initialize(selector_type)
        @selector_type = selector_type
      end

      def ==(other)
        self.class === other && selector_type == other.selector_type
      end

      def hash
        selector_type.hash
      end

      def eql?(other)
        self == other
      end

    end
  end
end
