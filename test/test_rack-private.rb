require 'helper'

class TestRackPrivate < Test::Unit::TestCase

  context 'one secret code' do
    setup { mock_app :code => 'secret' }
    
    should 'respond with private access from' do
      get "/"
      assert_equal 200, last_response.status
      assert_equal true, last_response.body.include?('Private access')
    end
    
    should 'respond with private access from if privat_code submitted is not valid' do
      post '/', :private_code => 'too bad'
      assert_equal 200, last_response.status
      assert_equal true, last_response.body.include?('Private access')
    end
    
    should 'redirect if private_code submitted is valid' do
      post '/', :private_code => 'secret'
      assert_equal 303, last_response.status
      assert_equal '/', last_response.location
    end
    
    should 'set private_code in session if private_code submitted is valid' do
      post '/', :private_code => 'secret'
      assert_equal 'secret', last_request.env['rack.session'][:private_code]
    end
    
    should 'respond normaly if private_code is in session' do
      post '/', {}, "rack.session" => { :private_code => 'secret' }
      assert_equal 200, last_response.status
      assert_equal true, last_response.body.include?('Hello world')
    end
  end

  context 'mutliple secret codes' do
    setup { mock_app :codes => ['secret','super-secret'] }
    
    should 'respond with private access from' do
      get "/"
      assert_equal 200, last_response.status
      assert_equal true, last_response.body.include?('Private access')
    end
    
    should 'respond with private access from if privat_code submitted is not valid' do
      post '/', :private_code => 'too bad'
      assert_equal 200, last_response.status
      assert_equal true, last_response.body.include?('Private access')
    end
    
    should 'redirect if private_code submitted is valid' do
      post '/', :private_code => 'secret'
      assert_equal 303, last_response.status
      assert_equal '/', last_response.location
    end
    
    should 'redirect if super private_code submitted is valid' do
      post '/', :private_code => 'super-secret'
      assert_equal 303, last_response.status
      assert_equal '/', last_response.location
    end
    
    should 'set private_code in session if private_code submitted is valid' do
      post '/', :private_code => 'secret'
      assert_equal 'secret', last_request.env['rack.session'][:private_code]
    end
    
    should 'respond normaly if private_code is in session' do
      post '/', {}, "rack.session" => { :private_code => 'secret' }
      assert_equal 200, last_response.status
      assert_equal true, last_response.body.include?('Hello world')
    end
  end
  
  context 'with exceptions' do
    setup do
      mock_app  :codes => ['secret','super-secret'], 
                :exceptions => ['foo']
    end
    
    should 'hide pages like normal' do
      get "/"
      assert_equal 200, last_response.status
      assert_equal true, last_response.body.include?('Private access')
    end
    
    should 'not hide specified page' do
      get "/foo"
      assert_equal 200, last_response.status
      assert_equal false, last_response.body.include?('Private access')
      assert_equal true, last_response.body.include?('Hello world')
    end
    
  end

end
