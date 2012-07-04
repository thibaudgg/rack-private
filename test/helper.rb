require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'rack/mock'
require 'rack/test'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rack/private'

class Test::Unit::TestCase
  include Rack::Test::Methods
  
  def app; Rack::Lint.new(@app); end
  
  def mock_app(options, &block)
    main_app = lambda { |env|
      request = Rack::Request.new(env)
      [200, { 'Content-Type' => 'text/html' }, ['Hello world']]
    }
    
    builder = Rack::Builder.new
    builder.use Rack::Private, options, &block
    builder.run main_app
    @app = builder.to_app
  end

end
