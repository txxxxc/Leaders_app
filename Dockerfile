FROM ruby:2.7.1

RUN apt-get update && apt-get install sqlite3 libsqlite3-dev -y

WORKDIR /app

ENV BUILD_PACKAGES="sqlite sqlite-devel"

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]

COPY . ./

CMD ["ruby", "app.rb", "-o", "0.0.0.0"]
EXPOSE 4567