# DockerEcho

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'docker_echo'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install docker_echo

## Usage

0. build [docker_echo_worker](https://github.com/kiyohara/docker_echo_worker) image

1. Create docker image

  ```
  $ docker build -t <username>/docker_echo .
  ```

2. Run docker container

  ```
  $ docker run -e 'DOCKER_HOST=${DOCKER_HOST}' -p 8081:8081 <username>/docker_echo
  ```

3. Check API

  ```
  $ curl -X GET http://<docker host>:8081/
  $ curl -X GET http://<docker host>:8081/ping
  $ curl -X POST -d 'data=xxx' http://<docker host>:8081/echo
  ```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/docker_echo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
