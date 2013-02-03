class TimeFilter
  def convert(interval, time)
    case interval
    when 'daily'
      then time
    when 'monthly'
      then time + "-01"
    end
  end
end
