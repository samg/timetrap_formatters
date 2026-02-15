class Timetrap::Formatters::Day
  include Timetrap::Helpers

  DATE_FORMAT = '%Y/%m/%d'

  def initialize(entries)
    @entries = entries
    @total_day_target = hours_to_seconds(Timetrap::Config['day_length_hours'].to_f)
    @width = Timetrap::Config['progress_width'].to_f
    @skip = Timetrap::Config['day_exclude_sheets'] || []
    @countdown = Timetrap::Config['day_countdown']
  end

  def output
    output = ''
    todays_duration = 0.0
    todays_entries = []
    
    # Determine the target date from entries or use today
    target_date = determine_target_date
    
    @entries.each do |entry|
      if is_target_date(entry[:start], entry.end_or_now, target_date) && !@skip.include?(entry.sheet)
        todays_duration += entry.duration
        todays_entries << entry
      end
    end
    percentage = ((todays_duration/@total_day_target)*100).to_i
    output << '[' << progress_bar(percentage) << '] ' << percentage.to_s << "%\n"
    remaining = @countdown ? format_seconds((@total_day_target - todays_duration).to_int) : ''
    output << "%%s%%%ds" % (@width - 7) % [format_total(todays_entries), remaining]
    return output
  end

  def determine_target_date
    # If entries exist, use the date of the last entry, otherwise use today
    # This allows the formatter to work with filtered date ranges
    if @entries.empty?
      Date.today
    else
      # Use the latest date among the entries
      @entries.map { |e| Date.parse(e[:start].strftime(DATE_FORMAT)) }.max || Date.today
    end
  end
  private :determine_target_date

  def is_target_date(start_time, end_time, target_date)
    return (Date.parse(start_time.strftime(DATE_FORMAT))..Date.parse(end_time.strftime(DATE_FORMAT))) === target_date
  end
  private :is_target_date

  def hours_to_seconds(hour_amount)
    return (hour_amount * 60.0 * 60.0)
  end
  private :hours_to_seconds

  def progress_bar(percentage)
    if percentage < 100
      hash_num = (@width/100.0) * percentage
      space_num = @width - hash_num
      return '#' * hash_num << ' ' * space_num
    else
      return '#' * @width
    end
  end
  private :progress_bar

end
