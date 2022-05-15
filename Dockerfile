FROM ubuntu:latest

USER root

RUN apt-get install -y openssl jq
RUN mkdir -p /work
RUN mkdir -p /seed
