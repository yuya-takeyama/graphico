class Graphico < Padrino::Application
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  enable :sessions

  ##
  # Caching support
  #
  # register Padrino::Cache
  # enable :caching
  #
  # You can customize caching store engines:
  #
  #   set :cache, Padrino::Cache::Store::Memcache.new(::Memcached.new('127.0.0.1:11211', :exception_retry_limit => 1))
  #   set :cache, Padrino::Cache::Store::Memcache.new(::Dalli::Client.new('127.0.0.1:11211', :exception_retry_limit => 1))
  #   set :cache, Padrino::Cache::Store::Redis.new(::Redis.new(:host => '127.0.0.1', :port => 6379, :db => 0))
  #   set :cache, Padrino::Cache::Store::Memory.new(50)
  #   set :cache, Padrino::Cache::Store::File.new(Padrino.root('tmp', app_name.to_s, 'cache')) # default choice
  #

  ##
  # Application configuration options
  #
  # set :raise_errors, true       # Raise exceptions (will stop application) (default for test)
  # set :dump_errors, true        # Exception backtraces are written to STDERR (default for production/development)
  # set :show_exceptions, true    # Shows a stack trace in browser (default for development)
  # set :logging, true            # Logging in STDOUT for development and file for production (default only for development)
  # set :public_folder, "foo/bar" # Location for static assets (default root/public)
  # set :reload, false            # Reload application files (default in development)
  # set :default_builder, "foo"   # Set a custom form builder (default 'StandardFormBuilder')
  # set :locale_path, "bar"       # Set path for I18n translations (default your_app/locales)
  # disable :sessions             # Disabled sessions by default (enable if needed)
  # disable :flash                # Disables sinatra-flash (enabled by default if Sinatra::Flash is defined)
  # layout  :my_layout            # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
  #

  ##
  # You can configure for a specified environment like:
  #
  #   configure :development do
  #     set :foo, :bar
  #     disable :asset_stamp # no asset timestamping for dev
  #   end
  #

  ##
  # You can manage errors like:
  #
  #   error 404 do
  #     render 'errors/404'
  #   end
  #
  #   error 505 do
  #     render 'errors/505'
  #   end
  #

  put '/stats/:service_name/:section_name/:name/:interval/:time' do
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
      time: params[:time],
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

  get "/stats/:service_name/:section_name/:name" do
    @service_name = params[:service_name]
    @section_name = params[:section_name]
    @chart_name   = params[:name]

    chart = Chart.first(
      service_name: params[:service_name],
      section_name: params[:section_name],
      name: params[:name],
    )
    stats = Stat.all(chart_id: chart.id)

    @data = {
      element: "chart",
      data: stats.map {|s|
        {
          date: s.time.strftime('%Y-%m-%d'),
          c: s.count
        }
      },
      xkey: "date",
      ykeys: ["c"],
      labels: [params[:name]]
    }

    render :chart
  end

  get '/stats/:service_name/:section_name' do
    @service_name = params[:service_name]
    @section_name = params[:section_name]

    @charts = Chart.find(
      service_name: @service_name,
      section_name: @section_name
    )

    render :section
  end

  get '/stats/:service_name' do
    @service_name = params[:service_name]

    @sections = Chart.sections(service_name: @service_name)

    render :service
  end

  get :index do
    @services = Chart.services

    render :index
  end

  def request_validator
    @request_validator ||= RequestValidator.new
  end
end
