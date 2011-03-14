module AntiSamy
  class CssValidator
    
    def initialize(policy)
      @policy = policy
    end
    
    # Check to see if this selector is valid according to the policy
    def valid_selector?(name,selector)
      case selector.selector_type
      when :SAC_CHILD_SELECTOR
        return valid_selector?(name,selector.selector) && valid_selector(name,selector.ancestor)
      when :SAC_CONDITIONAL_SELECTOR
        return valid_selector?(name,selector.selector) && valid_selector(name,selector.condition)
      when :SAC_DESCENDANT_SELECTOR
        return valid_selector?(name,selector.selector) && valid_selector(name,selector.ancestor)
      when :SAC_ELEMENT_NODE_SELECTOR
        return valid_simple_selector(selector)
      when :SAC_DIRECT_ADJACENT_SELECTOR
        return valid_selector?(name,selector.selector) && valid_selector(name,selector.sibling)
      when :SAC_ANY_NODE_SELECTOR
        return valid_simple_selector(selector)
      else
        raise ScanError, name
      end
    end
    
    # Validate a simple selector
    def valid_simple_selector(selector) #:nodoc:
      valid = false
      inclusion = @policy.expression("cssElementSelector")
      exclusion = @policy.expression("cssElementExclusion")
      begin
        css = selector.to_css
        valid = (css =~ inclusion) and (css !~ exclusion)
      rescue Exception=> e
      end
      valid     
    end
    
    # Check if a given condition is valid according to the policy
    def valid_condition?(name,condition)
      type = condtion.condition_type
      case type
      when :SAC_AND_CONDITION
        a = condtion.first
        b = condition.second
        return valid_condition?(name,a) && valid_condition?(name,b)
      when :SAC_CLASS_CONDITION
        inclusion = @policy.expression("cssClassSelector")
        exclusion = @policy.expression("cssClassExclusion")
        return validate_condition(condition,inclusion,exclusion)
      when :SAC_ID_CONDITION
        inclusion = @policy.expression("cssIDSelector")
        exclusion = @policy.expression("cssIDExclusion")
        return validate_condition(condition,inclusion,exclusion)
      when :SAC_PSEUDO_CLASS_CONDITION
        inclusion = @policy.expression("cssPseudoElementSelector")
        exclusion = @policy.expression("cssPsuedoElementExclusion")
        return validate_condition(condition,inclusion,exclusion)
      when :SAC_ONE_OF_ATTRIBUTE_CONDITION
        inclusion = @policy.expression("cssAttributeSelector")
        exclusion = @policy.expression("cssAttributeExclusion")
        return validate_condition(condition,inclusion,exclusion)
      when :SAC_ATTRIBUTE_CONDITION
        inclusion = @policy.expression("cssAttributeSelector")
        exclusion = @policy.expression("cssAttributeExclusion")
        return validate_condition(condition,inclusion,exclusion)
      when :SAC_BEGIN_HYPHEN_ATTRIBUTE_CONDITION
        inclusion = @policy.expression("cssAttributeSelector")
        exclusion = @policy.expression("cssAttributeExclusion")
        return validate_condition(condition,inclusion,exclusion)      
      else
        raise ScanError, name
      end
    end
    
    # validate the actual condition
    def validate_condition(condition,inclusion,exclusion) #:nodoc:
      valid = false
      begin
        css = condition.to_css
        valid = (css =~ inclusion) and (css !~ exclusion)
      rescue Exception=> e
      end
      valid
    end
    
    # Validate each property value according to teh policy
    def valid_property?(name,value)
      prop = @policy.property(name) unless name.nil?
      return false if prop.nil?
      value.each do |prop_value|
        v = prop_value.string_value
        return false unless validate_value(prop,v)
      end
      return true
    end
    
    # is this a valid property value
    def validate_value(property,value) #:nodoc:
      valid = false
      # Check static strings
      property.values.each do |al_val|
        valid = true if al_val.downcase.eql?(value.downcase)
      end
      # Check regular expressions
      unless valid
        property.expressions.each do |xp_val|
          valid = true if value =~ xp_value
        end
      end
      # check short hand
      unless valid
        property.refs.each do |ref|
          real = @policy.property(ref)
          if real
            valid = validate_value(real,value)
          end
        end
      end
      # We will check media above.
      return valid
    end
    
  end
end