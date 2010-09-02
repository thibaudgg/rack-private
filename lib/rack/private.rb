module Rack
  class Private
    
    def initialize(app, options = {})
      @app = app
      @options = options
    end
    
    def call(env)
      request = Rack::Request.new(env)
      
      # Check code in session and return Rails call if is valid
      return @app.call(env) if already_auth?(request)
      
      # If post method check :code_param value
      if request.post? && code_valid?(request.params["private_code"])
        request.session[:private_code] = request.params["private_code"]
        [301, { 'Content-Type' => 'text/plain', 'Location' => '/' }, ['Secret code is valid.']] # Redirect if code is valid
      else
        render_private_form
      end
    end
    
  private
    # Render staging html file
    def render_private_form
      [200, {'Content-Type' => 'application/html'}, [
        ::File.open(html_template, 'rb').read
      ]]
    end
    
    def html_template
      @options[:template_path] || ::File.expand_path('../private/index.html', __FILE__)
    end
    
    # Validate code
    def code_valid?(code)
      [@options[:code] || @options[:codes]].flatten.include?(code)
    end
    
    def already_auth?(request)
      code_valid?(request.session[:private_code])
    end
  end
end

