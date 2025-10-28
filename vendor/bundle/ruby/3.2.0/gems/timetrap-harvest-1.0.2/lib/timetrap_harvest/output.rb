class TimetrapHarvest::Output
  LINE_DIVIDER     = '-' * 80
  SUBMITTED_HEADER = "Submitted entries\n#{LINE_DIVIDER}"
  FAILED_HEADER    = "Failed entries\n#{LINE_DIVIDER}"

  attr_reader :results

  def initialize(results = {})
    @results = results
  end

  def generate
    messages = [stats]

    unless submitted.empty?
      messages << SUBMITTED_HEADER
      messages += submitted.map { |submitted| success_message(submitted[:notes]) }
      messages << "\n"
    end

    unless failed.empty?
      messages << FAILED_HEADER
      messages += failed.map { |failed| failed_message(failed[:note], failed[:error]) }
      messages << "\n"
    end

    messages.join("\n")
  end

  private

  def stats
    "Submitted: #{submitted.count}\nFailed: #{failed.count}\n"
  end

  def submitted
    results.fetch(:submitted, [])
  end

  def failed
    results.fetch(:failed, [])
  end

  def success_message(note)
    "Submitted: #{note}"
  end

  def failed_message(note, error)
    "Failed (#{error}): #{note}"
  end
end
