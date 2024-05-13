FROM koichan779/mariadb:10.11
MAINTAINER koichan779

ENV groonga_version=13.0.5 \
    mroonga_version=13.05

RUN dnf install -y \
      https://packages.groonga.org/almalinux/8/groonga-release-latest.noarch.rpm && \
    dnf install -y \
      mariadb-10.11-mroonga-${mroonga_version} && \
    dnf clean all

RUN cp /usr/share/mroonga/install.sql \
      /docker-entrypoint-initdb.d/00-mroonga-install.sql

COPY mysqld.cnf /etc/mysql/conf.d/
