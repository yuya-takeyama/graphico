Graphico.controllers :api, :v0 do
  put :stats, with: [:service_name, :section_name, :name, :interval, :time] do
    content_type :json

    unless request_validator.validate(params)
      status 400

      return {message: request_validator.message}.to_json
    end

    chart = Chart.first_or_new(
      service_name: params[:service_name],
      section_name: params[:section_name],
      name: params[:name],
    )

    unless chart.saved?
      chart.default_interval = params[:interval]

      unless chart.save
        status 500

        return {
          message: 'Failed to save chart',
          errors: chart.errors.full_messages
        }.to_json
      end
    end

    stat = Stat.first_or_new(
      chart_id: chart.id,
      interval: params[:interval],
      time: time_filter.convert(params[:interval], params[:time]),
    )

    stat.count = params['count']

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
