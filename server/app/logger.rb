class MainApp
  enable :logging
  configure :production do
    use Rack::CommonLogger, Logger.new(CONF.log.access, 'daily')
  end
  def logger
    if settings.development?
      @logger ||= Logger.new($stdout)
    else
      @logger ||= Logger.new(CONF.log.app, 'monthly')
    end
  end
end
