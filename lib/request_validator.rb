class RequestValidator
  attr_reader :message

  def validate(params)
    interval, time, type = params[:interval], params[:time], params['type']

    unless ['momentary', 'daily', 'monthly'].include? interval
      @message = 'Invalid interval is specified'

      return false
    end

    if interval == 'momentary' and type != 'gauge'
      @message = 'momentary interval only allows gauge as type'

      return false
    end

    unless correct_time_for?(interval, time)
      @message = "Invalid time is specified for #{interval} interval"

      return false
    end

    true
  end

  private
  def correct_time_for?(interval, time)
    res = case interval
    when 'momentary' then
      time =~ /^\d{4}(?:-\d{2}(?:-\d{2}(?: \d{2}(?::\d{2}(?::\d{2})?)?)?)?)?$/
    when 'daily' then
      time =~ /^\d{4}-\d{2}-\d{2}$/
    when 'monthly' then
      time =~ /^\d{4}-\d{2}$/
    end

    res == 0
  end
end
