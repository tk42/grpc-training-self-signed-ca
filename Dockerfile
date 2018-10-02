FROM centos

RUN yum install -y epel-release \
  && yum install -y openssl jq \
  && mkdir -p /work \
  && mkdir -p /seed