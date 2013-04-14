PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)

require 'rubygems'
require 'spork'
require 'coveralls'
Coveralls.wear!

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  require File.expand_path(File.dirname(__FILE__) + "/../config/boot")

  RSpec.configure do |conf|
    conf.mock_with :rr
    conf.include Rack::Test::Methods
  end

  def app
    ##
    # You can handle all padrino applications using instead:
    #   Padrino.application
    Graphico.tap { |app|  }
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.

end
