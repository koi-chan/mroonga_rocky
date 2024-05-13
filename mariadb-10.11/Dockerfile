FROM almalinux:8
MAINTAINER koi-chan

ENV groonga_version=13.0.5 \
    mroonga_version=13.05  \
    mariadb_version=10.11.4

ENV LANG C.UTF-8

ENV mariadb_rpm_uri=https://archive.mariadb.org/mariadb-10.11.4/yum/rhel8-amd64/rpms/ \
    mariadb_rpm_filename=MariaDB-server-10.11.4-1.el8.x86_64.rpm

COPY MariaDB.repo /etc/yum.repos.d/

RUN dnf install -y \
      https://packages.groonga.org/almalinux/8/groonga-release-latest.noarch.rpm \
      epel-release \
      wget && \
    dnf module -y disable mysql && \
    dnf module -y disable mariadb && \
    dnf config-manager --enable powertools && \
    dnf config-manager --enable epel

# yum で最新版を自動取得させると、バージョン指定の齟齬が出てインストールできない
COPY Dockerfile MariaDB-* /tmp/
RUN for name in server client common shared devel; do \
      target=`echo $mariadb_rpm_filename |sed -e "s/server/${name}/"` && \
      if [ ! -f /tmp/${target} ]; then \
        wget -P /tmp ${mariadb_rpm_uri}${target} ; \
      fi ; \
    done

RUN yum install -y \
#      MariaDB-{server,client,common,shared,devel} && \
      /tmp/MariaDB* && \
    rm -rf /var/lib/mysql && \
    mkdir /var/lib/mysql && \
    chown mysql.mysql /var/lib/mysql

# Install gosu.  https://github.com/tianon/gosu
COPY --from=tianon/gosu /gosu /usr/local/bin

RUN mkdir /docker-entrypoint-initdb.d

COPY healthcheck.sh /usr/local/bin
COPY docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/healthcheck.sh && \
    chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306

HEALTHCHECK --start-period=5m \
    CMD mariadb -e 'SELECT @@datadir;' || exit 1

CMD ["mariadbd"]     
