module RSAC
  module Selectors
    class SiblingSelector < SimpleSelector
      attr_accessor :selector, :sibling_selector
      alias :sibling :sibling_selector

      def initialize(selector, sibling)
        super(:SAC_DIRECT_ADJACENT_SELECTOR)

        @selector = selector
        @sibling_selector = sibling
      end

      def to_css
        "#{selector.to_css} + #{sibling.to_css}"
      end

      def to_xpath(prefix=true)
        "#{selector.to_xpath(prefix)}/following-sibling::#{sibling.to_xpath(false)}"
      end

      def specificity
        selector.specificity.zip(sibling.specificity).map { |x,y| x + y }
      end

      def ==(other)
        super && selector == other.selector && sibling == other.sibling
      end

      def hash
        [selector, sibling].hash
      end
    end
  end
end
