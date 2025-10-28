class TimetrapHarvest::Harvester
  attr_reader :results, :client

  def initialize(results, client)
    @results = results
    @client  = client
  end

  def harvest
    results.each do |result|
      if result.key? :error
        failed << result
      else
        client.post(result)

        submitted << result
      end
    end

    { submitted: submitted, failed: failed }
  end

  def submitted
    @submitted ||= []
  end

  def failed
    @failed ||= []
  end
end
