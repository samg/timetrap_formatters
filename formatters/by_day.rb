module Timetrap
  module Formatters
    class ByDay
      attr_accessor :output
      include Timetrap::Helpers

      def initialize entries
        self.output = ''

        by_date = entries.inject({}) do |h, e|
          date = e.start.to_date
          h[date] ||= []
          h[date] << e
          h
        end

        id_heading = Timetrap::CLI.args['-v'] ? 'Id ' : ''
        longest_sheet = entries.inject('Sheet'.length) {|l, e| [e.sheet.rstrip.length, l].max}
        longest_note = entries.inject('Notes'.length) {|l, e| [e.note.rstrip.length, l].max}

        by_date.keys.sort.each do |date|
          self.output << "## #{format_date date} ##\n\n"

          self.output << "    %sSheet   Start      End        Duration   Notes\n" % (' '*(longest_sheet-5))

          last_sheet = nil

          by_date[date].sort_by(&:start).each do |line|
            self.output <<  "%-4s%#{longest_sheet}s%11s -%9s%10s    %s\n" % [
              (Timetrap::CLI.args['-v'] ? line.id : ''),
              line.sheet == last_sheet ? '' : line.sheet,
              format_time(line.start),
              format_time(line.end),
              format_duration(line.duration),
              line.note
            ]
            last_sheet = line.sheet
          end

          self.output << "    %s\n" % ('─'*(40+longest_sheet + longest_note))
          self.output << "    Total%43s\n" % format_total(by_date[date])
          self.output << "\n"

        end

        if by_date.size > 1
          self.output <<  "%s\n" % ('─'*(4+40+longest_sheet + longest_note))
          self.output <<  "Grand Total%41s\n" % format_total(by_date.values.flatten)
        end
      end
    end
  end
end
