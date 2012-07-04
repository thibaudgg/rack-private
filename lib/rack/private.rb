module Rack
  class Private

    def initialize(app, options = {}, &block)
      @app = app
      @options = options
      @exceptions = []

      unless options[:except].nil?
        options[:except].each {|exception| except(exception) }
      end

      instance_eval(&block) if block_given?
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
      @exceptions.find {|exception| exception?(request, exception)}
    end

    def exception?(request, exception)
      path, method = *exception
      matches_path?(request, path) && matches_method?(request, method)
    end

    def matches_path?(request, path)
      request.url.match(path)
    end

    def matches_method?(request, method)
      return true if method.nil?
      request.request_method.to_s.downcase == method.values.first.to_s.downcase
    end

    def except(match, method = nil)
      @exceptions << [match, method]
    end
  end
end

