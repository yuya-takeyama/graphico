Graphico.controllers :api, :v0 do
  put :stats, with: [:service_name, :section_name, :name, :interval, :time] do
    content_type :json

    filtered_params = request_filter.filter(params)

    unless request_validator.validate(filtered_params)
      status 400

      return {message: request_validator.message}.to_json
    end

    chart = Chart.first_or_new(
      service_name: filtered_params[:service_name],
      section_name: filtered_params[:section_name],
      name: filtered_params[:name],
    )

    unless chart.saved?
      chart.type             = filtered_params['type']
      chart.default_interval = filtered_params[:interval]

      unless chart.save
        status 500

        return {
          message: 'Failed to save chart',
          errors: chart.errors.full_messages
        }.to_json
      end
    end

    if chart.countable? and chart.default_interval != filtered_params[:interval]
      status 406
      return {
        message: "This chart only accepts #{chart.default_interval} interval because it's countable chart"
      }.to_json
    end

    stat = Stat.first_or_new(
      chart_id: chart.id,
      interval: filtered_params[:interval],
      time: time_filter.convert(filtered_params[:interval], filtered_params[:time]),
    )

    stat.count = filtered_params['count']

    if stat.save
      status 204
    else
      status 500
      {
        message: 'Failed to save stat',
        errors: stat.errors.full_messages
      }.to_json
    end
  end
end
