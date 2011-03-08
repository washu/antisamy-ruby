module AntiSamy
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
