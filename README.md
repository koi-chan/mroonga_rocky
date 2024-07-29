# mroonga_rocky

* Dockerfile 中の mroonga / mariadb のバージョンを書き換える
* docker build -t koichan779/mroonga:${version}
* docker tag <container id> koichan779/mroonga:${version}
* docker image push koichan779/mroonga:${version}
