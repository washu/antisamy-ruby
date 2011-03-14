require 'open-uri'
module AntiSamy
  # Css Scanner class
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
      raise ScanError, "Max input Exceeded #{input.size} > #{limit}" if input.size > limit
      space_remaining = limit - input.size
      # check poilcy stuff
      if input =~ /^\s*<!\[CDATA\[(.*)\]\]>\s*$/
        input = $1
      end
      # validator needs token sizes
      filter = CssFilter.new(@policy,tag)
      parser = RSAC::Parser.new(filter)
      parser.error_handler = filter
      parser.logger = filter
      parser.parse(input)
      # Populate the results
      results = ScanResults.new(Time.now)
      if @policy.directive(Policy::USE_XHTML)
        result.clean_html = "<![CDATA[#{filter.clean}]]>"
      else
        results.clean_html = filter.clean
      end
      results.messages = filter.errors
      # check for style sheets
      sheets = filter.style_sheets
      max_sheets = @policy.directive(Policy::MAX_SHEETS).to_i
      max_sheets ||= 1
      import_sheets = 0
      if sheets.size > 0
        timeout = 1000
        if @policy.directive(Policy::CONN_TIMEOUT)
          timeout = @policy.directive(Policy::CONN_TIMEOUT).to_i
        end
        timeout /= 1000
        sheets.each do |sheet|
          sheet_content = ''
          begin
            open(sheet,{:read_timeout => timeout}) do |f|
              sheet_content = f.read(space_remaining)
            end
            space_remaining -= sheet_content.size
            if import_sheets > max_sheets
              # skip any remaing sheets if we exceeded the import count
              results.messages << ScanMessage.new(ScanMessage::ERROR_CSS_IMPORT_EXCEEDED,"@import",sheet)
              break;
            end
            
            if sheet_content.size > 0
              #r = scan_sheet(sheet_content,space_remaining)
              parser.parse(sheet_content)
              #results.messages << r.messages
              #results.messages.flatten!
              import_sheets += 1
            end
            
            if space_remaining <= 0 or sheet_content.empty?
              results.messages << ScanMessage.new(ScanMessage::ERROR_CSS_IMPORT_INPUT_SIZE,"@import",sheet)
              break
            end
          rescue Exception => e
            results.messages << ScanMessage.new(ScanMessage::ERROR_CSS_IMPORT_FAILURE,"@import",sheet)
          end
          # check the sheet rules
        end
      end      
      results
    end
  end
end
