FROM alpine:3.17 as base
WORKDIR /work
RUN apk add neon

FROM ubuntu:20.04 as tar_builder
COPY docker/setup_tarbuilder.sh .
RUN sh setup_tarbuilder.sh && rm -f setup_tarbuilder.sh

FROM tar_builder as build_tarball
WORKDIR /sitecopy-0.16.6
COPY . .
RUN mv docker/build_tarball.sh .. && rm -rf docker
RUN sh /build_tarball.sh

FROM base as builder_base
RUN apk add alpine-sdk neon-dev

FROM builder_base as builder
COPY --from=build_tarball /sitecopy-0.16.6.tar.gz .
COPY docker/make_install.sh .
RUN sh make_install.sh sitecopy-0.16.6

FROM base
COPY --from=builder /usr/local/bin/sitecopy /usr/bin
ENTRYPOINT ["sitecopy"]
CMD ["--help"]
