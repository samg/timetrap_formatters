# text formatter for sum of spent time grouped by note.
#
# $ t d other -f sum_notes
#
# Timesheet: other
#   Duration   Notes
#   0:46:03    bank
#   0:27:37    blogs
#   0:52:36    coffee
#   0:48:24    lunch
#   0:18:02    tea
#
# Alexander Sapozhnikov
# http://shoorick.ru
# shoorick@cpan.org

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
