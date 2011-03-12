module AntiSamy
  class CssValiator
    
    def initialize(policy)
      @policy = policy
    end
    
    def valid_condition(condition,inclusion,exclusion)
      
    end
    
    # check the value of each property value
    def valid_property?(name,value)
      prop = @policy.property(name) unless name.nil?
      return false if prop.nil?
      value.each do |prop_value|
        v = prop_value.string_value
        return false unless valid_value(prop,v)
      end
      return true
    end
    
    # is this a valid property value
    def valid_value(property,value)
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
            valid = valid_value(real,value)
          end
        end
      end
      # We will check media above.
      return valid
    end
    
  end
end