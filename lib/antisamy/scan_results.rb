module AntiSamy
  class ScanError < StandardError; end
  # Scan message, it will contain a message key, tag and optionally content, value
  class ScanMessage
    # error.tag.notfound
    ERROR_TAG_NOT_IN_POLICY = "error.tag.notfound"
    # error.tag.removed
    ERROR_TAG_DISALLOWED = "error.tag.removed"
    # error.tag.filtered
    ERROR_TAG_FILTERED = "error.tag.filtered"
    # error.tag.encoded
    ERROR_TAG_ENCODED = "error.tag.encoded"
    # error.css.tag.malformed
    ERROR_CSS_TAG_MALFORMED = "error.css.tag.malformed"
    # error.css.attribute.malformed
    ERROR_CSS_ATTRIBUTE_MALFORMED = "error.css.attribute.malformed"
    # error.attribute.invalid.filtered
    ERROR_ATTRIBUTE_CAUSE_FILTER = "error.attribute.invalid.filtered"
    # error.attribute.invalid.encoded
    ERROR_ATTRIBUTE_CAUSE_ENCODE = "error.attribute.invalid.encoded"
    # error.attribute.invalid.filtered
    ERROR_ATTRIBUTE_INVALID_FILTERED = "error.attribute.invalid.filtered"
    # error.attribute.invalid.removed
    ERROR_ATTRIBUTE_INVALID_REMOVED = "error.attribute.invalid.removed"
    # error.attribute.notfound
    ERROR_ATTRIBUTE_NOT_IN_POLICY = "error.attribute.notfound"
    # error.attribute.invalid
    ERROR_ATTRIBUTE_INVALID = "error.attribute.invalid"

    attr_reader :tag, :content, :value, :msgkey
    def initialize(msgkey, tag, content=nil,value=nil)
      @msgkey = msgkey
      @tag = tag
      @content = content
      @value = value
    end
    def to_s
      "#{self.msgkey} #{@tag} #{@content} #{@value}"
    end
  end
  
  # Container of scan results, provides a list of ScanMessage indicating
  # why elements were removed from the resulting html
  class ScanResults
    attr_reader :scan_start, :scan_end
    attr_accessor :messages, :clean_html
    def initialize(scan_start,scan_end = nil)
      @errors = []
      @scan_start = scan_start
      @scan_end = scan_end
      @clean_html = ''
    end

    # Get the calculated scan time
    def scan_time
      @scan_end ||= Time.now
      (@scan_end - @scan_start).round(2)
    end

  end
end
