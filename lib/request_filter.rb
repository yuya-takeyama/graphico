class RequestFilter
  def filter(params)
    filtered_params = params.dup

    if params[:interval] == 'momentary'
      filtered_params['type'] = 'gauge' unless params['type']
    else
      filtered_params['type'] = 'countable' unless params['type']
    end

    unless filtered_params['default_interval']
      if filtered_params['type'] == 'gauge'
        if filtered_params[:time] =~ /^\d{4}-\d{2}-\d{2}$/
          filtered_params['default_interval'] = 'daily'
        elsif filtered_params[:time] =~ /^\d{4}-\d{2}$/
          filtered_params['default_interval'] = 'monthly'
        end
      else
        filtered_params['default_interval'] = filtered_params[:interval]
      end
    end

    filtered_params
  end
end
