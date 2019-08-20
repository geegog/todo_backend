FROM elixir:1.9.0
ENV DEBIAN_FRONTEND=noninteractive
ENV MIX_HOME=/opt/mix

# Install hex
RUN mix local.hex --force

# Install rebar
RUN mix local.rebar --force

# Install the Phoenix framework itself
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force

# Install NodeJS and the NPM
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y -q nodejs

# Suggested https://hexdocs.pm/phoenix/installation.html
RUN apt-get update && apt-get install -y \
    inotify-tools \
 && apt-get install -y apt-utils \
 && apt-get install -y build-essential \
 && rm -rf /var/lib/apt/lists/*

# When this image is run, make /app the current working directory
ENV APP_HOME /opt/app
RUN mkdir -p $APP_HOME
ADD . $APP_HOME
WORKDIR $APP_HOME

EXPOSE 4000

CMD ["mix", "phx.server"]