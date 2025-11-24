# text formatter for sum of spent time grouped by week with progress bar.
# Can adapt with progess bar, change the formatter fields as you which:
# The progress bar can go above 100% you see the delimitation with the characters difference : ████▉▉▉▉
#
# $ t d other -f sum_weeks
#
# TARGET_HOURS = 28.8
# BAR_WIDTH = 25
# CHAR_NORMAL = "█"
# CHAR_OVER   = "▉"
# CHAR_EMPTY  = "-"
# 
# Week       Hours     %        Progress
# 2024-53     62.01     215%   █████████████████████████▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉
# 2025-01      5.65      20%   ████---------------------
# 2025-02     35.57     124%   █████████████████████████▉▉▉▉▉▉
# 2025-03     34.83     121%   █████████████████████████▉▉▉▉▉
# 2025-04     22.83      79%   ███████████████████------
# 2025-05     21.62      75%   ██████████████████-------
#
#
# Dorian Gravier
# https://dgrv.github.io/dorian-gravier/




module Timetrap
  module Formatters
    class SumWeeks
      attr_accessor :output
      include Timetrap::Helpers

      TARGET_HOURS = 28.8
      BAR_WIDTH = 25
      CHAR_NORMAL = "█"
      CHAR_OVER   = "▉"
      CHAR_EMPTY  = "-"

      def initialize(entries)
        self.output = ""

        weeks = Hash.new(0)

        # Sum weekly durations
        entries.each do |e|
          next unless e.end
          week = e.start.strftime("%Y-%W")
          weeks[week] += e.duration
        end

        self.output << "   Week       Hours     %        Progress\n"

        weeks.keys.sort.each do |w|
          hours = (weeks[w] / 3600.0).round(2)

          pct = (hours / TARGET_HOURS * 100).round

          # For up to 100%
          filled_normal = [(hours / TARGET_HOURS * BAR_WIDTH).floor, BAR_WIDTH].min
          empty = [BAR_WIDTH - filled_normal, 0].max

          # If over 100%, extend with CHAR_OVER
          if hours > TARGET_HOURS
            over_units = ((hours - TARGET_HOURS) / TARGET_HOURS * BAR_WIDTH).round
          else
            over_units = 0
          end

          bar =
            CHAR_NORMAL * filled_normal +
            CHAR_EMPTY  * empty +
            CHAR_OVER   * over_units

          self.output << "%10s     %5.2f     %3d%%   %s\n" %
            [w, hours, pct, bar]
        end
      end
    end
  end
end
