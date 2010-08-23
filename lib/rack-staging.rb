# Hi! I'am rack middleware!
# I was born for protect you staging application from anonymous and prying

# My author's name was Aleksandr Koss. Mail him at kossnocorp@gmail.com
# Nice to MIT you!

module Rack
  class Staging
    
    def initialize(app, options = {})
      @app = app
      @options = options
    end
    
    def call(env)
      request = Rack::Request.new(env)
      
      # Check code in session and return Rails call if is valid
      return @app.call(env) if already_auth?(request)
      
      # If post method check :code_param value
      if request.post? and code_valid?(request.params["staging_code"])
        request.session[:staging_code] = request.params["staging_code"]
        [301, {'Location' => '/'}, ''] # Redirect if code is valid
      else
        render_staging
      end
    end
    
  private
    # Render staging html file
    def render_staging
      [200, {'Content-Type' => 'text/html'}, [
        ::File.open(html_template, 'rb').read
      ]]
    end
    
    def html_template
      @options[:template_path] || ::File.expand_path('../rack-staging/index.html', __FILE__)
    end
    
    # Validate code
    def code_valid?(code)
      @options[:code] == code
    end
    
    def already_auth?(request)
      code_valid?(request.session[:staging_code])
    end
  end
end

