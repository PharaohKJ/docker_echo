FROM ubuntu

MAINTAINER Tomokazu Kiyohara <tomokazu.kiyohara@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get -y install ruby
RUN apt-get -y install ruby-dev
RUN apt-get -y install make
RUN apt-get -y install libssl-dev

RUN apt-get -y install git
RUN gem install --no-ri --no-rdoc rake
RUN gem install --no-ri --no-rdoc bundler

### for devel
# RUN gem install --no-ri --no-rdoc rack
# RUN gem install --no-ri --no-rdoc puma
# RUN gem install --no-ri --no-rdoc grape
# RUN gem install --no-ri --no-rdoc docker-api
# RUN gem install --no-ri --no-rdoc faraday
# RUN gem install --no-ri --no-rdoc faraday_middleware
# COPY pkg/docker_echo-*.gem /tmp/
# RUN gem install --no-ri --no-rdoc /tmp/docker_echo-*.gem
###

RUN git clone https://github.com/kiyohara/docker_echo.git /tmp/docker_echo
RUN mkdir -p /etc/docker_echo
RUN cp /tmp/docker_echo/etc/*.yml /etc/docker_echo/
RUN cd /tmp/docker_echo; rake build
RUN gem install --no-ri --no-rdoc /tmp/docker_echo/pkg/docker_echo-*.gem
RUN rm -rf /tmp/docker_echo;

ENTRYPOINT [ "docker_echo" ]
CMD [ "/etc/docker_echo/config.yml" ]

