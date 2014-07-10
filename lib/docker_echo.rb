require "docker_echo/version"

module DockerEcho
  $LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__)))

  require 'rack'
  require 'puma'
  require 'grape'

  require 'docker'
  require 'faraday'
  require 'faraday_middleware'

  require 'docker_echo/api'
  require 'docker_echo/config_middleware'
  require 'docker_echo/server'
end
