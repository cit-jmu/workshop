FROM ruby:2.1.5
MAINTAINER Leighton Shank <shanklt@jmu.edu>

ENV APP_NAME workshop
ENV APP_DIR /var/www/apps/${APP_NAME}/

VOLUME ${APP_DIR}

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p ${APP_DIR}

WORKDIR ${APP_DIR}

COPY Gemfile ${APP_DIR}
COPY Gemfile.lock ${APP_DIR}
RUN bundle install

COPY . ${APP_DIR}

ENTRYPOINT ["bin/docker-entrypoint"]

EXPOSE 9292
CMD ["serve"]
