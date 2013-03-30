require 'json'

class MorrisChart
  def initialize(params = {})
    raise 'No chart specified' unless params[:chart]
    raise 'No stats specified' unless params[:stats]
    raise 'No interval specified' unless params[:interval]

    @chart    = params[:chart]
    @stats    = params[:stats]
    @element  = params[:element] || 'chart'
    @interval = params[:interval]
  end

  def to_hash
    @hash ||= {
      element: @element,
      data: data,
      xkey: 'time',
      ykeys: ['c'],
      labels: [@chart.name],
      xLabels: xlabels
    }
  end

  def to_json
    @json ||= to_hash.to_json
  end

  def data
    @data ||= filter_data(@stats).map { |s|
      {
        time: s.time.strftime(time_format),
        c: s.count
      }
    }
  end

  def filter_data(stats)
    if @chart.countable?
      if @chart.default_interval == 'daily' and @interval == 'daily'
        stats
      elsif @chart.default_interval == 'daily' and @interval == 'monthly'
        stats.group_by {|s|
          DateTime.new(s.time.year, s.time.month, 1)
        }.reduce([]) {|sum, e|
          time, stats = e
          sum << Stat.new(time: time, count: stats.reduce(0) {|sum, s| sum + s.count })
        }
      end
    else
      stats
    end
  end

  def time_format
    case @interval
    when 'daily'
      then '%Y-%m-%d'
    when 'monthly'
      then '%Y-%m'
    end
  end

  def xlabels
    case @interval
    when 'daily'
      then 'day'
    when 'monthly'
      then 'month'
    end
  end

  def empty?
    @stats.empty?
  end
end
