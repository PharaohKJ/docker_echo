module DockerEcho
  module Serverengine
    def initialize
      # p worker_id
    end

    def run
      config_path = ARGV[0]
      opts = { worker_id: worker_id }

      if config_path && File.exist?(config_path)
        opts.merge!(YAML.load_file(config_path))
      end

      server = DockerEcho::Server.new(opts)
      server.run
    end

    def stop
    end
  end
end
