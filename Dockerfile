FROM ruby:3.1.4
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs npm iputils-ping
RUN npm install -g yarn esbuild sass vite
RUN mkdir /lets_travel
WORKDIR /lets_travel
RUN gem install bundler:2.5.6
RUN gem install foreman
COPY Gemfile /lets_travel/Gemfile
COPY Gemfile.lock /lets_travel/Gemfile.lock
COPY . /lets_travel
RUN bundle install
RUN yarn install
RUN yarn build
RUN rails assets:precompile
CMD ["rails", "server", "-b", "0.0.0.0"]