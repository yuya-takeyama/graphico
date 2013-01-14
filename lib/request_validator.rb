class RequestValidator
  attr_reader :message

  def validate(params)
    interval, time = params[:interval], params[:time]

    unless ['daily'].include? interval
      @message = 'Invalid interval is specified'

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
    case interval
    when 'daily' then
      time =~ /^\d{4}-\d{2}-\d{2}$/
    end
  end
end
