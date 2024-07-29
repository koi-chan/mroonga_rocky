FROM almalinux:8
MAINTAINER koi-chan

ENV groonga_version=14.0.4 \
    mroonga_version=14.04  \
    mariadb_version=10.11.8

ENV LANG C.UTF-8

ENV mariadb_rpm_uri=https://archive.mariadb.org/mariadb-${mariadb_version}/yum/rhel8-amd64/rpms/ \
    mariadb_rpm_filename=MariaDB-server-${mariadb_version}-1.el8.x86_64.rpm

COPY MariaDB.repo /etc/yum.repos.d/

RUN dnf install -y \
      epel-release \
      wget \
      https://packages.groonga.org/almalinux/8/groonga-release-latest.noarch.rpm && \
    dnf module -y disable mysql && \
    dnf module -y disable mariadb && \
    dnf config-manager --enable powertools && \
    dnf config-manager --enable epel

# yum で最新版を自動取得させると、バージョン指定の齟齬が出てインストールできない
COPY Dockerfile MariaDB-*-${mariadb_version}-* /tmp/
RUN for name in server client common shared devel; do \
      target=`echo $mariadb_rpm_filename |sed -e "s/server/${name}/"` && \
      if [ ! -f /tmp/${target} ]; then \
        wget -P /tmp ${mariadb_rpm_uri}${target} ; \
      fi ; \
    done

RUN dnf install -y \
#      MariaDB-{server,client,common,shared,devel} && \
      /tmp/MariaDB* && \
    rm -f /tmp/MariaDB* && \
    rm -rf /var/lib/mysql && \
    mkdir /var/lib/mysql && \
    chown -R mysql.mysql /var/lib/mysql

VOLUME /var/lib/mysql

RUN dnf install -y \
      mariadb-10.11-mroonga-${mroonga_version} && \
    dnf clean all

# Install gosu.  https://github.com/tianon/gosu
COPY --from=tianon/gosu /gosu /usr/local/bin

COPY healthcheck.sh /usr/local/bin
COPY docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/healthcheck.sh && \
    chmod +x /usr/local/bin/docker-entrypoint.sh

RUN mkdir /docker-entrypoint-initdb.d && \
    cp /usr/share/mroonga/install.sql \
      /docker-entrypoint-initdb.d/00-mroonga-install.sql

COPY mysqld.cnf /etc/mysql/conf.d/

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306

HEALTHCHECK --start-period=5m \
    CMD mariadb -e 'SELECT @@datadir;' || exit 1

CMD ["mariadbd"]
