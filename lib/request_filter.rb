class RequestFilter
  def filter(params)
    filtered_params = params.dup

    if params[:interval] == 'momentary'
      filtered_params['type'] = 'gauge' unless params['type']
    else
      filtered_params['type'] = 'countable' unless params['type']
    end

    filtered_params
  end
end
