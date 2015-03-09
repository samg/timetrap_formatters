class Timetrap::Formatters::Total
  include Timetrap::Helpers

  def initialize(entries)
    @entries = entries
  end

  def output
    total = 0.0
    @entries.each do |entry|
      total += entry.duration / 3600.0
    end
    return "%.3f\n" % total
  end
end
