module Rack
  class Private
    
    def initialize(app, options = {})
      @app = app
      @options = options
    end
    
    def call(env)
      request = Rack::Request.new(env)
      
      # Check code in session and return Rails call if is valid
      return @app.call(env) if (already_auth?(request) || public_page?(request))
      
      # If post method check :code_param value
      if request.post? && code_valid?(request.params["private_code"])
        request.session[:private_code] = request.params["private_code"]
        body = "<html><body>Secret code is valid.</body></html>"
        [303, { 'Content-Type' => 'text/html', 'Location' => '/' }, [body]] # Redirect if code is valid
      else
        render_private_form
      end
    end
    
  private
    # Render staging html file
    def render_private_form
      [200, {'Content-Type' => 'text/html'}, [
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
    
    # Checks if the url matches one of our exception strings or regexs
    def public_page?(request)
      @options[:except] && @options[:except].find {|x| request.url.match(x)}
    end
    
  end
end

