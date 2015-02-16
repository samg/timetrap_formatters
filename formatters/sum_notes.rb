module Timetrap
  module Formatters
    class SumNotes
      attr_accessor :output
      include Timetrap::Helpers

      def initialize(entries)
        self.output = ''
        sheets = entries.inject({}) do |h, e|
          h[e.sheet] ||= []
          h[e.sheet] << e
          h
        end
        
        sheets.keys.sort.each do |sheet|
          self.output <<  "Timesheet: #{sheet}\n"
          sheets[sheet].each_with_index do |e, i|
            #from_current_day << e
            self.output <<  "%10s    %s\n" % [
              format_duration(e.duration),
              e.note
            ]
          end
        end
      end
    end
  end
end
