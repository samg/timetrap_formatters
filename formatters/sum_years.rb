# text formatter for sum of days per year with specific tag (@tag)
# Days for tags are counted using starttime and endtime. This is not counting the number of lines !!!
# For this example I have 2 tags @event and @ka
# Can adapt with progess bar, change the formatter fields as you which:
#
#
# TARGET_HOURS = 28.8 * 52
# TARGET_EVENT_DAYS = 55
# TARGET_KA_DAYS    = 25
# BAR_WIDTH = 15
# CHAR_NORMAL = "█"
# CHAR_OVER   = "▉"
# CHAR_EMPTY  = "-"
# has_event = note.include?("@event")
# has_ka    = note.include?("@ka")
#
# $ t d -f sum_years
# Explanation:
#   - Days for @event and @ka are counted using starttime and endtime.
#   Year      Hours   %H     Progress Hours                       DaysEv   %D    Progress Days                   DaysKA   %K     Progress KA
#    2024      62.01    4%    4% ---------------                  0    0%    0% ---------------                  0    0%    0% ---------------
#    2025    1647.82  110%  110% ███████████████▉▉               64  116%  116% ███████████████▉▉               39  156%  156% ███████████████▉▉▉▉▉▉▉▉
#
#
# Dorian Gravier
# https://dgrv.github.io/dorian-gravier/



module Timetrap
  module Formatters
    class SumYears
      attr_accessor :output
      include Timetrap::Helpers

      TARGET_HOURS = 28.8 * 52
      TARGET_EVENT_DAYS = 55
      TARGET_KA_DAYS    = 25

      BAR_WIDTH = 15

      CHAR_NORMAL = "█"
      CHAR_OVER   = "▉"
      CHAR_EMPTY  = "-"

      def initialize(entries)
        self.output = ""

        years_hours = Hash.new(0)
        years_event_days = Hash.new(0)
        years_ka_days    = Hash.new(0)

        entries.each do |e|
          next unless e.end
          note = e.note || ""

          has_event = note.include?("@event")
          has_ka    = note.include?("@ka")

          # Sum hours per start year
          start_year = e.start.year
          years_hours[start_year] += e.duration

          # Count days from start to end
          days_count = (e.end.to_date - e.start.to_date).to_i + 1
          years_event_days[start_year] += days_count if has_event
          years_ka_days[start_year]    += days_count if has_ka
        end

       self.output << "Explanation:\n"
       self.output << "  - Days for @event and @ka are counted using starttime and endtime.\n\n"


        # Header
        self.output << "  Year      Hours   %H     Progress Hours                       DaysEv   %D    Progress Days                   DaysKA   %K     Progress KA\n"

        years = (years_hours.keys + years_event_days.keys + years_ka_days.keys).uniq.sort
        years.each do |year|
          hours = (years_hours[year] / 3600.0).round(2)
          pct_hours = (hours / TARGET_HOURS * 100).round

          # Hours bar
          filled_h = [(hours / TARGET_HOURS * BAR_WIDTH).floor, BAR_WIDTH].min
          empty_h  = [BAR_WIDTH - filled_h, 0].max
          over_h   = hours > TARGET_HOURS ? ((hours - TARGET_HOURS) / TARGET_HOURS * BAR_WIDTH).round : 0
          bar_hours = CHAR_NORMAL * filled_h + CHAR_EMPTY * empty_h + CHAR_OVER * over_h

          # Event bar
          event_days = years_event_days[year]
          pct_event = (event_days / TARGET_EVENT_DAYS.to_f * 100).round
          filled_e = [(event_days / TARGET_EVENT_DAYS.to_f * BAR_WIDTH).floor, BAR_WIDTH].min
          empty_e  = [BAR_WIDTH - filled_e, 0].max
          over_e   = event_days > TARGET_EVENT_DAYS ? ((event_days - TARGET_EVENT_DAYS) / TARGET_EVENT_DAYS.to_f * BAR_WIDTH).round : 0
          bar_event = CHAR_NORMAL * filled_e + CHAR_EMPTY * empty_e + CHAR_OVER * over_e

          # KA bar
          ka_days = years_ka_days[year]
          pct_ka = (ka_days / TARGET_KA_DAYS.to_f * 100).round
          filled_k = [(ka_days / TARGET_KA_DAYS.to_f * BAR_WIDTH).floor, BAR_WIDTH].min
          empty_k  = [BAR_WIDTH - filled_k, 0].max
          over_k   = ka_days > TARGET_KA_DAYS ? ((ka_days - TARGET_KA_DAYS) / TARGET_KA_DAYS.to_f * BAR_WIDTH).round : 0
          bar_ka = CHAR_NORMAL * filled_k + CHAR_EMPTY * empty_k + CHAR_OVER * over_k

          self.output << "%7s   %8.2f  %3d%%  %3d%% %-27s  %5d  %3d%%  %3d%% %-27s  %5d  %3d%%  %3d%% %s\n" %
            [year, hours, pct_hours, pct_hours, bar_hours,
             event_days, pct_event, pct_event, bar_event,
             ka_days, pct_ka, pct_ka, bar_ka]
        end
      end
    end
  end
end
