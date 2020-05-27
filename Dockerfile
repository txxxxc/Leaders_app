FROM ruby:2.6.6-stretch

RUN apt-get update && apt-get install sqlite3 libsqlite3-dev -y

WORKDIR /app

RUN gem install bundler:2.1.4
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]

COPY . ./

CMD ["ruby", "app.rb", "-o", "0.0.0.0"]
EXPOSE 4567