FROM ruby:3.0.3

RUN apt update -q && \
    apt install libpq-dev postgresql-client \
    build-essential curl git libvips node-gyp \
    pkg-config python-is-python3 -yqq --no-install-recommends npm && \
    apt clean

ARG NODE_VERSION=20.11.0
ARG YARN_VERSION=1.22.21
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
     /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
     npm install -g yarn@$YARN_VERSION && \
     rm -rf /tmp/node-build-master

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

ADD Gemfile Gemfile.lock ./
RUN bundle install -j 8

ADD . .

ENTRYPOINT [ "/app/entrypoint.sh" ]
