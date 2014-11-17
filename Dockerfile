FROM ruby:2.1.5
MAINTAINER Leighton Shank <shanklt@jmu.edu>

ENV app_name workshop
ENV app_dir /usr/src/apps/${app_name}/

VOLUME /tmp/sockets
VOLUME /usr/src/apps

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p ${app_dir}
WORKDIR ${app_dir}

COPY Gemfile ${app_dir}
COPY Gemfile.lock ${app_dir}
RUN bundle install

COPY . ${app_dir}
#RUN bin/rake assets:precompile

CMD ["bin/puma", "-b unix:///tmp/sockets/workshop.sock"]
