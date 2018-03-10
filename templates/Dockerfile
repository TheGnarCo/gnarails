FROM ruby:2.4.2

# use a newer version of Node to use Yarn
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

# Install Google Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN apt-get update && apt-get install -y google-chrome-stable

# nodejs: Rails needs a JS runtime
# cmake: required by Rugged, dependency of Pronto
RUN apt-get update -qq \
    && apt-get install -y -qq nodejs cmake google-chrome-stable chromedriver

RUN npm install -g yarn

RUN mkdir /app
WORKDIR /app

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install

ADD . /app
