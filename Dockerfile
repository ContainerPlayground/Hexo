FROM  ubuntu:20.04
LABEL Maintainer="Mauricio Araya"

ENV LANGUAGE=en_US
ENV LANG=en_US.UTF-8

ENV LANGUAGE=en_US
ENV LANG=en_US.UTF-8
RUN export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE='true'

RUN export DEBIAN_FRONTEND='noninteractive' APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE='true' \
    && apt-get --yes update && apt-get upgrade -y \
    && apt-get install --yes \
        apt-transport-https \
        curl \
        git \
        gnupg2 \
        openssh-client \
        unzip

RUN curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
COPY files/nodesource.list /etc/apt/sources.list.d/nodesource.list
RUN export DEBIAN_FRONTEND='noninteractive' APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE='true' \
    && apt-get --yes update \
    && apt-get install --yes nodejs \
    && npm install npm -g \
    && npm install hexo-cli -g

WORKDIR /tmp
RUN curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install

RUN useradd -m -d /home/playground \
               -s /bin/bash \
               -c "Hexo Playground" playground \
    && mkdir -p /home/playground/.ssh \
                /home/playground/.config \
                /home/playground/bin \
                /home/playground/workdir \
    && chown -R playground:playground /home/playground

RUN rm -rf /tmp/* \
    && apt-get --yes clean

WORKDIR /home/playground/workdir

EXPOSE 4000
