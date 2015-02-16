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
          self.output <<  "\nTimesheet: #{sheet}\n"
          self.output << "   Duration   Notes\n"

          durations = {}
          sheets[sheet].each do |e|
            durations[e.note] ||= 0
            durations[e.note]  += e.duration
          end

          durations.keys.sort.each do |d|
            self.output <<  "%10s    %s\n" % [
              format_duration(durations[d]),
              d
            ]
          end
        end
      end
    end
  end
end
