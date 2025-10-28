require_relative './timetrap_harvest/version'
require_relative './timetrap_harvest/config'
require_relative './timetrap_harvest/network_client'
require_relative './timetrap_harvest/formatter'
require_relative './timetrap_harvest/harvester'
require_relative './timetrap_harvest/output'

begin
  Module.const_get('Timetrap')
rescue NameError
  module Timetrap;
    module Formatters; end
    Config = { 'harvest' => { 'aliases' => {} } }
  end
end

class Timetrap::Formatters::Harvest
  attr_reader :entries
  attr_writer :client, :config

  def initialize(entries)
    @entries = entries
  end

  def output
    results = entries.map { |entry| TimetrapHarvest::Formatter.new(entry, config).format }

    harvester = TimetrapHarvest::Harvester.new(results, client)
    results   = harvester.harvest

    TimetrapHarvest::Output.new(results).generate
  end

  private

  def config
    @config ||= TimetrapHarvest::Config.new
  end

  def client
    @client ||= TimetrapHarvest::NetworkClient.new(config)
  end
end
