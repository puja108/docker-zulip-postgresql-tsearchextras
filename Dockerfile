FROM quay.io/sameersbn/ubuntu:14.04.20151013
MAINTAINER galexrt@googlemail.com

ENV PG_VERSION=9.4 \
    PG_USER=postgres \
    PG_HOME=/var/lib/postgresql \
    PG_RUNDIR=/run/postgresql \
    PG_LOGDIR=/var/log/postgresql

ENV PG_CONFDIR="/etc/postgresql/${PG_VERSION}/main" \
    PG_BINDIR="/usr/lib/postgresql/${PG_VERSION}/bin" \
    PG_DATADIR="${PG_HOME}/${PG_VERSION}/main"

ADD zulip_english.stop /usr/share/postgresql/9.3/tsearch_data/zulip_english.stop
ADD en_us.dict /var/cache/postgresql/dicts/en_us.dict
ADD en_us.affix /var/cache/postgresql/dicts/en_us.affix
ADD entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    wget --quiet -O - /root/zulip-ppa.asc https://zulip.com/dist/keys/zulip-ppa.asc | apt-key add - && \
    echo 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' > /etc/apt/sources.list.d/pgdg.list && \
    echo "deb http://ppa.launchpad.net/tabbott/zulip/ubuntu trusty main" > /etc/apt/sources.list.d/zulip.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y postgresql-${PG_VERSION} postgresql-client-${PG_VERSION} postgresql-contrib-${PG_VERSION} postgresql-9.3-tsearch-extras && \
    rm -rf ${PG_HOME} && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /usr/share/postgresql/${PG_VERSION}/tsearch_data && \
    ln -s /var/cache/postgresql/dicts/en_us.dict /usr/share/postgresql/${PG_VERSION}/tsearch_data/en_us.dict && \
    ln -s /var/cache/postgresql/dicts/en_us.affix /usr/share/postgresql/${PG_VERSION}/tsearch_data/en_us.affix && \
    ln -s /usr/share/postgresql/9.3/extension/tsearch_extras.control /usr/share/postgresql/9.4/extension/tsearch_extras.control && \
    ln -s /usr/share/postgresql/9.3/extension/tsearch_extras--1.0.sql /usr/share/postgresql/9.4/extension/tsearch_extras--1.0.sql

EXPOSE 5432/tcp
VOLUME ["${PG_HOME}", "${PG_RUNDIR}"]
CMD ["/sbin/entrypoint.sh"]
