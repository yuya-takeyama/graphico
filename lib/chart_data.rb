require 'json'

class ChartData
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
      labels: [@chart.name]
    }
  end

  def to_json
    @json ||= to_hash.to_json
  end

  def data
    @data ||= @stats.map { |s|
      {
        time: s.time.strftime(time_format),
        c: s.count
      }
    }
  end

  def time_format
    case @interval
    when 'daily'
      then '%Y-%m-%d'
    end
  end
end
