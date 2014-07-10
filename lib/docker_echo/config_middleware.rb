module DockerEcho
  class ConfigMiddleware
    def initialize(app, config)
      @app, @config = app, config
    end

    def call(env)
      env['config'] = @config
      @app.call(env)
    end
  end
end
