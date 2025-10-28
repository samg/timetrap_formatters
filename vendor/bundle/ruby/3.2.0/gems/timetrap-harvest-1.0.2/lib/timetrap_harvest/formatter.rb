class TimetrapHarvest::Formatter
  HARVESTABLE_REGEX = /@(.*)/

  attr_reader :entry, :config

  def initialize(entry, config)
    @entry  = entry
    @config = config
  end

  def format
    if alias_config && entry[:end]
      { notes:      entry[:note],
        hours:      hours_for_time(entry[:start], entry[:end]),
        project_id: project_id.to_i,
        task_id:    task_id.to_i,
        spent_at:   entry[:start].strftime('%Y%m%d')
      }
    elsif !entry[:end]
      { error: 'Entry not ended yet', note: entry[:note] }
    elsif code
      { error: 'Missing task alias config', note: entry[:note] }
    else
      { error: 'No task alias provided', note: entry[:note] }
    end
  end

  def project_id
    alias_config[:project_id]
  end

  def task_id
    alias_config[:task_id]
  end

  def alias_config
    config.alias_config(code)
  end

  def round_in_minutes
    config.round_in_minutes
  end

  def code
    if match = HARVESTABLE_REGEX.match(entry[:note])
      code = match[1]
    end
  end

  def hours_for_time(start_time, end_time)
    minutes = (end_time - start_time) / 60
    rounded = round(minutes)
    hours   = (rounded / 60)
  end

  def round(value, nearest = round_in_minutes)
    (value % nearest).zero? ? value : (value + nearest) - (value % nearest)
  end
end
