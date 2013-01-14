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

  [:daily].each do |type|
    get "/graphs/:service_name/:section_name/#{type}/:name" do
      graph = Graph.first(
        service_name: params[:service_name],
        section_name: params[:section_name],
        graph_name: params[:name],
        type: type
      )
      stats = Stat.all(graph_id: graph.id)
      @type  = type

      @data = {
        element: "graph",
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

      render 'graphs/graph'
    end

    get "/graphs/:service_name/:section_name/#{type}" do
      @graphs = Graph.all(
        service_name: params[:service_name],
        section_name: params[:section_name],
        type: type
      )
      @type = type

      render 'graphs/types'
    end
  end

  get '/graphs/:service_name/:section_name' do
    @graphs = Graph.all(fields: ["service_name", "section_name", "type"], unique: true)

    render 'graphs/sections'
  end

  get '/graphs/:service_name' do
    @graphs = Graph.all(fields: ["service_name", "section_name"], unique: true)

    render 'graphs/services'
  end

  get :index do
    @graphs = Graph.all(fields: ["service_name"], unique: true)

    render :index
  end
end
