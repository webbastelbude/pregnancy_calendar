FROM ruby:2.3
MAINTAINER Holger Quick <mail@holger-quick.com>

RUN apt-get update && \
    apt-get install -y net-tools

# Install gems
ENV APP_HOME /app
ENV HOME /root
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY Gemfile* $APP_HOME/
RUN bundle install

# Upload source
COPY . $APP_HOME

# Start server
ENV PORT 1234
EXPOSE 1234
CMD ["ruby", "pregnancy_calendar.rb"]