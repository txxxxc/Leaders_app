FROM ruby:2.7.1-alpine

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]

COPY . ./

CMD ["ruby", "app.rb", "-o", "0.0.0.0"]
EXPOSE 4567