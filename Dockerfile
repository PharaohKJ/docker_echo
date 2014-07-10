FROM base

MAINTAINER Tomokazu Kiyohara <tomokazu.kiyohara@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get -y install ruby
RUN apt-get -y install ruby-dev
RUN apt-get -y install make
RUN apt-get -y install libssl-dev

RUN mkdir -p /etc/docker_echo
COPY etc/config.yml /etc/docker_echo/
COPY etc/config_devel.yml /etc/docker_echo/

### for devel speed up
# RUN gem install --no-ri --no-rdoc rack
# RUN gem install --no-ri --no-rdoc puma
# RUN gem install --no-ri --no-rdoc grape
# RUN gem install --no-ri --no-rdoc docker-api
# RUN gem install --no-ri --no-rdoc faraday
# RUN gem install --no-ri --no-rdoc faraday_middleware
###

COPY pkg/docker_echo-0.0.1.gem /tmp/
RUN gem install --no-ri --no-rdoc /tmp/docker_echo-0.0.1.gem

ENTRYPOINT [ "docker_echo" ]
CMD [ "/etc/docker_echo/config.yml" ]

