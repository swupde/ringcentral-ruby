require 'test/unit'
require 'ringcentral'
require 'dotenv'

class RingCentralTest < Test::Unit::TestCase
  def test_class_variables
    assert_equal 'https://platform.devtest.ringcentral.com', RingCentral.SANDBOX_SERVER
    assert_equal 'https://platform.ringcentral.com', RingCentral.PRODUCTION_SERVER
  end

  def test_initializer
    rc = RingCentral.new('app_key', 'app_secret', RingCentral.SANDBOX_SERVER)
    assert_equal 'app_key', rc.app_key
    assert_equal 'app_secret', rc.app_secret
    assert_equal 'https://platform.devtest.ringcentral.com', rc.server
    assert_equal true, rc.auto_refresh
  end

  def test_authorize_uri
    rc = RingCentral.new('app_key', 'app_secret', RingCentral.SANDBOX_SERVER)
    assert_equal RingCentral.SANDBOX_SERVER + '/restapi/oauth/authorize?client_id=app_secret&redirect_uri=https%3A%2F%2Fexample.com&response_type=code&state=mystate', rc.authorize_uri('https://example.com', 'mystate')
  end

  def test_password_flow
    Dotenv.load
    rc = RingCentral.new(ENV['appKey'], ENV['appSecret'], ENV['server'])
    assert_equal nil, rc.token

    # create token
    rc.authorize(username: ENV['username'], extension: ENV['extension'], password: ENV['password'])
    assert_not_equal nil, rc.token

    # refresh token
    rc.refresh
    assert_not_equal nil, rc.token

    # revoke token
    rc.revoke
    assert_equal nil, rc.token
  end
end
