Rack::Private
=============

> Private Rack middleware purpose is to protect your Rack application from anonymous via a secret code form.

Installation
------------

    gem install rack-private

Usage
-----

``` ruby
require 'rack-private'
use Rack::Private :code => 'secret'
```

You can also define multiple codes.

``` ruby
use Rack::Private :codes => ['secret', 'super-secret']
```

And provide your own template.

``` ruby
use Rack::Private :code => 'secret', :template_path => Rails.root.join("app/templates/private.html")
```

### Note on Patches/Pull Requests ###

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Author
------

* [Thibaud Guillaume-Gentil](http://github.com/thibaudgg)
