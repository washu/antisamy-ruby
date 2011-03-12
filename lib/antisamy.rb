require 'nokogiri'
require 'antisamy/csspool/rsac'
require 'antisamy/model/attribute'
require 'antisamy/model/tag'
require 'antisamy/model/css_property'
require 'antisamy/policy'
require 'antisamy/scan_results'
require 'antisamy/html/handler'
require 'antisamy/css/css_validator'
require 'antisamy/css/css_filter'
require 'antisamy/css/css_scanner'
require 'antisamy/html/sax_filter'
require 'antisamy/html/scanner'

module AntiSamy
  class << self

    # Setup the input encoding, defaults to UTF-8
    def input_encoding=(encoding)
      @@input_encoding = encoding
    end

    # Setup the output encoding defaults to UTF-8
    def output_encoding=(encoding)
      @@output_encoding = encoding
    end

    # Scan the input using the provided policy.
    # will raise an exception if there is some form of scannign error
    def scan(input,policy)
      scanner = Scanner.new(policy)
      @@input_encoding ||= Scanner::DEFAULT_ENCODE
      @@output_encoding ||=  Scanner::DEFAULT_ENCODE
      clean = scanner.scan(input,@@input_encoding, @output_encoding)
      clean
    end

    # Create a policy out of the provided file
    # will use a string or any IO object that can be read
    # will raise an exception if the policy fails to validate
    def policy(policy_file)
      Policy.new(policy_file)
    end

  end
end
