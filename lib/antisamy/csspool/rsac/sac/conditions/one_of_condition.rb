module RSAC
  module Conditions
    class OneOfCondition < AttributeCondition

      def initialize(local_name, value)
        super(local_name, value, true, :SAC_ONE_OF_ATTRIBUTE_CONDITION)
      end

      def to_css
        "[#{local_name}~=#{value}]"
      end

      def to_xpath
        "[contains(@#{local_name}, '#{value}')]"
      end
    end
  end
end
