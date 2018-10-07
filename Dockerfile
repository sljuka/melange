FROM bitwalker/alpine-elixir:1.6.6

WORKDIR /opt/melange

#Copy the source folder into the Docker image
COPY . .

#Install dependencies and build Release
ENV MIX_ENV=prod
RUN apk update && \
    apk add -u musl musl-dev musl-utils postgresql-client nodejs-npm build-base && \
    npm install -g yarn
RUN mix deps.get --only prod
RUN mix deps.compile
RUN mix compile
RUN cd assets && \
    yarn install && \
    yarn deploy && \
    cd .. && \
    mix phx.digest
RUN mix release

#Extract Release archive to /rel for copying in next stage
RUN APP_NAME="melange" && \
    RELEASE_DIR=`ls -d _build/prod/rel/$APP_NAME/releases/*/` && \
    mkdir /export && \
    tar -xf "$RELEASE_DIR/$APP_NAME.tar.gz" -C /export

#================
#Deployment Stage
#================

#Set environment variables and expose port
EXPOSE 4000
ENV REPLACE_OS_VARS=true
ENV PORT=4000

#Change user
USER default

#Set default entrypoint and command
CMD ["./run.sh"]
