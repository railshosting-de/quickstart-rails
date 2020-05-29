FROM ruby:2.6.6-alpine
RUN apk add --update --no-cache build-base nodejs yarn mariadb-dev postgresql-dev sqlite-dev tzdata git imagemagick

ENV PATH="/usr/local/bundle/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/rails/.gem/ruby/2.6.0/bin"
RUN adduser rails --gecos "" --disabled-password
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
USER rails
RUN gem install rails
ADD meta.tgz /meta
WORKDIR /home/rails
ENV GEM_HOME=/home/rails/.gem/ruby/2.6.0:/usr/local/bundle:/usr/local/lib/ruby/gems/2.6.0
ENV GEM_PATH=/home/rails/.gem/ruby/2.6.0:/usr/local/bundle:/usr/local/lib/ruby/gems/2.6.0
ENV BUNDLE_PATH=/home/rails/.gem
ENTRYPOINT ["/entrypoint.sh"]
