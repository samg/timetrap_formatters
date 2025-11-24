Similar to "t d" but print all in 1 line to allow grep
# Dorian Gravier
# https://dgrv.github.io/dorian-gravier/


# $ t d | grep @event
# Sat Jul 05, 2025   06:30:00 - 19:00:00  12:30:00    Example1 @event @ka
# Sun Jul 06, 2025   06:30:00 - 21:00:00  14:30:00    Example1 @event @ka
#                                                     @event @ka
#                                                     @event @ka
#                                                     @event @ka
# Sat Aug 09, 2025   10:00:00 - 21:00:00  11:00:00    Example2 @event
#                     07:12:44 - 21:00:00  13:47:16    Example2 @event
# 
# to
# 
# $ t d -f oneline| grep @event
# 508      2025-07-04 20:08:28 - 2025-07-04 23:08:28      3:00:00    Example1 @event @ka
# 729      2025-07-05 06:30:00 - 2025-07-05 19:00:00     12:30:00    Example1 @event @ka
# 730      2025-07-06 06:30:00 - 2025-07-06 21:00:00     14:30:00    Example1 @event @ka
# 555      2025-08-01 18:00:00 - 2025-08-01 23:00:00      5:00:00    Example3 @event @ka
# 556      2025-08-02 06:00:00 - 2025-08-02 18:30:00     12:30:00    Example3 @event @ka
# 557      2025-08-03 06:00:00 - 2025-08-03 21:30:00     15:30:00    Example3 @event @ka
# 574      2025-08-09 10:00:00 - 2025-08-09 21:00:00     11:00:00    Example2 @event
# 576      2025-08-10 07:12:44 - 2025-08-10 21:00:00     13:47:16    Example2 @event



module Timetrap
  module Formatters
    class Oneline
      attr_accessor :output
      include Timetrap::Helpers

      def initialize(entries)
        self.output = ""
        entries.each do |e|
          start_str = e.start.strftime("%Y-%m-%d %H:%M:%S")
          end_str   = e.end.strftime("%Y-%m-%d %H:%M:%S") rescue "-"
          duration  = format_duration(e.duration)
          note      = (e.note || "").gsub("\n"," ")  # remove newlines
          self.output << "%3d      %s - %s     %s    %s\n" % [e.id, start_str, end_str, duration, note]
        end
      end
    end
  end
end
