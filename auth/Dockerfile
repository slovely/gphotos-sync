FROM golang:1.24-bookworm AS build

ENV DEFAULT_GPHOTOS_CDP_VERSION=github.com/slovely/gphotos-cdp@3662773
ENV GO111MODULE=on

ARG GPHOTOS_CDP_VERSION=$DEFAULT_GPHOTOS_CDP_VERSION
RUN go install $GPHOTOS_CDP_VERSION

#FROM dorowu/ubuntu-desktop-lxde-vnc
FROM tiryoh/ubuntu-desktop-lxde-vnc

# Setup environment variables
ENV HOME=/home/abc \
    USER=abc \
    PGID=1000 \
    PUID=1000 \
    CHROME_PACKAGE=google-chrome-stable_current_amd64.deb

RUN \
    # Create a non-root user
    addgroup abc --gid "${PGID}" --quiet \
    && adduser abc --uid "${PUID}" --gid "${PGID}" --disabled-password --gecos "" --quiet \
    && echo 'abc ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Install/update Chrome
RUN \
    wget https://dl.google.com/linux/direct/$CHROME_PACKAGE && \
    dpkg --force-all -i ./$CHROME_PACKAGE && \
    rm ./$CHROME_PACKAGE && \
    rm -rf /var/lib/apt/lists/*

ENV \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    CRON_SCHEDULE="0 0 * * *" \
    RESTART_SCHEDULE= \
    CHROME_PACKAGE=google-chrome-stable_current_amd64.deb \
    DEBIAN_FRONTEND=noninteractive \
    LOGLEVEL=INFO \
    HEALTHCHECK_HOST="https://hc.simonlovely.co.uk" \
    HEALTHCHECK_ID= \
    ALBUMS= \
    WORKER_COUNT=6 \
    GPHOTOS_CDP_ARGS=


RUN apt-get update && apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        cron \
        exiftool \
        jq \
        wget \
        sudo \
        libc6 \
    --no-install-recommends && \
    wget https://dl.google.com/linux/direct/$CHROME_PACKAGE && \
    apt install -y ./$CHROME_PACKAGE && \
    rm ./$CHROME_PACKAGE && \
    rm -rf /var/lib/apt/lists/*


COPY --from=build /go/bin/gphotos-cdp /usr/bin/
#COPY ../src ./app/

#RUN chmod +x /app/*.sh

COPY startup2.sh /startup2.sh

ENTRYPOINT [ "/startup2.sh" ]
