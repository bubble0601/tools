require 'sinatra/namespace'
require 'sinatra/reloader' if development?
require 'rack/session/dalli'
require 'rack/protection'

class MainApp < Sinatra::Base
  register Sinatra::Namespace
  configure :development do
    register Sinatra::Reloader
  end

  set :root, ROOT
  set :public_folder, './static'

  # expires_after must be less than 2592000(=30days)
  # expires_after controls the expiration of both the cookie and the memcached
  use Rack::Session::Dalli,
      namespace: "#{CONF.app.name}:session",
      memcache_server: 'localhost:11211',
      expire_after: 3600 * 24 * 28,
      key: CONF.session.name,
      same_site: :lax,
      httponly: true

  # set :sessions, same_site: :lax
  set :sessions, secure: true if CONF.server.ssl

  # checks referer and authenticity token
  # accept if either is valid
  # the base64 encoded authenticity token is acquired by Rack::Protection::AuthenticityToken.token(session)
  use Rack::Protection::RemoteToken

  use Rack::Protection::SessionHijacking if production?
end
