class Timetrap::Formatters::SumNotes
  def initialize(entries)
    @entries = entries
  end

  def output
    @entries.map{|entry| entry[:note]}.join("\n")
  end
end
