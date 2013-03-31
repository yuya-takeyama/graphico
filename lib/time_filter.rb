class TimeFilter
  def convert(interval, time)
    case interval
    when 'momentary' then
      if time =~ /^\d{4}$/
        "#{time}-01-01 00:00:00"
      elsif time =~ /^\d{4}-\d{2}$/
        "#{time}-01 00:00:00"
      elsif time =~ /^\d{4}-\d{2}-\d{2}$/
        "#{time} 00:00:00"
      elsif time =~ /^\d{4}-\d{2}-\d{2} \d{2}$/
        "#{time}:00:00"
      elsif time =~ /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}$/
        "#{time}:00"
      elsif time =~ /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/
        time
      end
    when 'daily' then
      time
    when 'monthly' then
      time + "-01"
    end
  end
end
