module Timetrap
  module Formatters
    class Fraction
      attr_accessor :output
      include Timetrap::Helpers

      def format_time t
        return '' unless t.respond_to?(:strftime)
        return t.strftime('%H:%M')
      end

      def initialize entries
        self.output = ''
        sheets = entries.inject({}) do |h, e|
          h[e.sheet] ||= []
          h[e.sheet] << e
          h
        end
        (sheet_names = sheets.keys.sort).each do |sheet|
          self.output <<  "Timesheet: #{sheet}\n"
          id_heading = Timetrap::CLI.args['-v'] ? 'Id' : '  '
          self.output <<  "#{id_heading}  Day                Start   End     Duration        Notes\n"
          last_start = nil
          from_current_day = []
          sheets[sheet].each_with_index do |e, i|
            from_current_day << e
            self.output <<  "%-4s%16s%8s -%6s%10s% 7.2f  %s\n" % [
              (Timetrap::CLI.args['-v'] ? e.id : ''),
              format_date_if_new(e.start, last_start),
              format_time(e.start),
              format_time(e.end),
              format_duration(e.duration),
              e.duration / 3600.0,
              e.note
            ]

            nxt = sheets[sheet].to_a[i+1]
            if nxt == nil or !same_day?(e.start, nxt.start)
              self.output <<  "%46s% 7.2f\n" % [
                format_total(from_current_day),
                from_current_day.inject(0) {|sum, e| sum + (e.duration/3600.0)}
              ]
              from_current_day = []
            else
            end
            last_start = e.start
          end
          self.output <<  <<-OUT
    ---------------------------------------------------------
          OUT
          self.output <<  "    Total%37s% 7.2f\n" % [
            format_total(sheets[sheet]),
            sheets[sheet].inject(0) {|s, e| s + (e.duration / 3600.0)}
          ]
          self.output <<  "\n" unless sheet == sheet_names.last
        end
        if sheets.size > 1
          self.output <<  <<-OUT
-------------------------------------------------------------
          OUT
          self.output <<  "Grand Total%35s% 7.2f\n" % [
            format_total(sheets.values.flatten),
            sheets.values.flatten.inject(0) {|s, e| s + (e.duration / 3600.0)}
          ]
        end
      end
    end
  end
end
