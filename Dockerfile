FROM lambci/lambda:build-ruby2.7
WORKDIR /app
COPY Gemfile* ./
RUN bundle install --deployment --without development:test --jobs 8
COPY app ./app
COPY lambda_function.rb ./
COPY deploy_lambda.sh ./