module AntiSamy

  class CssScanner
    attr_accessor :policy, :errors
    # Create a scanner with a given policy
    def initialize(policy)
      @policy = policy
      @errors = []
    end
    # Scan the input using the provided input and output encoding
    # will raise an error if nil input or the maximum input size is exceeded
    def scan_inline(a_value,name,max_input)
      return scan_sheet("#{name} { #{a_value} }",max_input,name)
    end

    def scan_sheet(input,limit,tag = nil)
      raise ArgumentError if input.nil?
      raise ScanError, "Max input Exceeded" if input.size > limit
      # check poilcy stuff
      if input =~ /^\\s*<!\\[CDATA\\[(.*)\\]\\]>\\s*$/
        input = $1
      end
      # validator needs token sizes
      filter = CssFilter.new(@policy,tag)
      parser = RSAC::Parser.new(filter)
      parser.parse(input)
      # Populate the results
      results = ScanResults.new(Time.now)
      results.clean_html = filter.clean
      results.messages = filter.errors
      # check for style sheets
      if filter.clean.empty?
        raise ScanError
      end
      results
    end
  end
end
