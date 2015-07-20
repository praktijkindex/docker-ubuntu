# Version: 0.0.1

# Dockerfile for a Rails application using Nginx and Unicorn

# Select ubuntu as the base image

FROM ubuntu:14.04
MAINTAINER Michael van der Luit "mvdluit@depraktijkindex.nl"

# Install nginx, nodejs and curl
RUN apt-get update -q
RUN apt-get install -qy nano
RUN apt-get install -qy nginx
RUN apt-get install -qy curl
RUN apt-get install -qy nodejs
# pg lib
RUN apt-get install -qy libpq-dev
# ruby lib
RUN apt-get install -y build-essential zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libreadline-dev libncurses5-dev libffi-dev curl
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Install Ruby
RUN mkdir /tmp/ruby
WORKDIR /tmp/ruby
RUN curl -L --progress ftp://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.6.tar.gz | tar xz
WORKDIR ruby-2.1.6
RUN ./configure --disable-install-rdoc
RUN make
RUN make install
RUN rm -rf /tmp/ruby
WORKDIR /

RUN gem install bundler --no-ri --no-rdoc

# Add configuration files in repository to filesystem
ADD config/container/nginx-sites.conf /etc/nginx/sites-enabled/default
ADD config/container/start-server.sh /usr/bin/start-server
RUN chmod +x /usr/bin/start-server

# Add rails project to project directory
ADD ./ /rails

# set WORKDIR
WORKDIR /rails

# permissions
RUN chmod 0755 bin/rails bin/bundle bin/rake

# bundle install (production)
RUN bundle install --without development test

# to enable nano command in container
ENV TERM xterm

# Publish port 80
EXPOSE 80

# Startup commands
ENTRYPOINT /usr/bin/start-server
