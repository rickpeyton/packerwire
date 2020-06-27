FROM lambci/lambda:build-ruby2.7
COPY entrypoint.sh /entrypoint.sh
COPY Gemfile* ./
RUN bundle install --deployment --without development:test --jobs 8
COPY app ./
COPY lambda_function.rb ./
ENTRYPOINT ["/entrypoint.sh"]
