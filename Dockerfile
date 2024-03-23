FROM --platform=$BUILDPLATFORM golang:1.22.1 AS builder

ARG TARGETPLATFORM

ARG TARGETOS

ARG TARGETARCH

ENV APP_HOME /go/src/app

# Corrected the mkdir command to use the environment variable
RUN mkdir -p $APP_HOME

WORKDIR $APP_HOME

COPY go.mod go.sum ./

RUN go mod download

COPY tmpl tmpl

COPY statics statics

COPY Godeps Godeps

COPY *.go .

# Build
RUN CGO_ENABLED=1 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -a -installsuffix cgo -x -ldflags '-extldflags "-static"' -o bin/app .

RUN mkdir -p bundle && mv bin Godeps tmpl statics bundle
###############
# Final Stage
###############
FROM --platform=$TARGETPLATFORM alpine:latest

# You don't necessarily need to redefine APP_HOME here, but it's fine to keep it
ENV APP_HOME /go/src/app

# Make sure the WORKDIR is set to the correct path
WORKDIR $APP_HOME

ENV PORT=3333

RUN addgroup -S app \
    && adduser -S -G app app -h "$APP_HOME" \
    && apk --no-cache add \
    ca-certificates curl netcat-openbsd \
    libc6-compat

RUN chown -R app:app ./

# Ensure the path in COPY --from=builder is correct
COPY --from=builder --chown=app:app $APP_HOME/bundle .

EXPOSE 3333

USER app

CMD ["bin/app"]
