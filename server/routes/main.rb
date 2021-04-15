require 'json'

class MainApp
  helpers UtilityHelpers

  helpers do
    def json(obj)
      content_type :json
      cache_control :no_cache
      body obj.to_json
    end
  end

  # Sinatra will check if a static file exists in public folder and serve it before checking for a matching route.
  not_found do
    if @is_api
      return
    elsif request.path.start_with?('/static')
      halt 404
    else
      send_file '../static/index.html'
    end
  end

  error 500 do
    # logger.info env.inspect
    logger.error env['sinatra.error']&.message || '500 Internal server error'
  end
end
