# Hi! I'am rack middleware!
# I was born for protect you staging application from anonymous and prying

# My author's name was Aleksandr Koss. Mail him at kossnocorp@gmail.com
# Nice to MIT you!

module Rack
  class Staging
    def initialize app, options = {}
      @app = app
      @options = {
        :session_key => :staging_auth,
        :code_param => :code
      }.merge options
    end

    def call env
      request = Rack::Request.new env

      # Check code in session and return Rails call if is valid

      return @app.call env if \
        request.session[@options[:session_key]] != nil and
        request.session[@options[:session_key]] != '' and
        code_valid? request.session[@options[:session_key]]

      # If post method check :code_param value

      if request.post? and code_valid? request.params[@options[:code_param].to_s]
        request.session[@options[:session_key]] =
          request.params[@options[:code_param].to_s]

        [301, {'Location' => '/'}, ''] # Redirect if code is valid
      else
        render_staging
      end
    end

  private

    # Render staging html file

    def render_staging
      [200, {'Content-Type' => 'text/html'}, [
        ::File.open(@options[:template_path], 'rb').read
      ]]
    end

    # Validate code

    def code_valid? code
      @options[:auth_codes].include? code
    end
  end
end

