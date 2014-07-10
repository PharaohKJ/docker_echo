module DockerEcho
  class Server
    def initialize(options)
      @options = options

      @port = @options['port'] || 8081
    end

    def run
      config = @options

      app = Rack::Builder.new do
        use DockerEcho::ConfigMiddleware, config
        run DockerEcho::API
      end
      @rack_server = Rack::Server.new({
        app: app,
        server: 'puma',
        Port: @port
      })
      @rack_server.start
    end
  end
end
