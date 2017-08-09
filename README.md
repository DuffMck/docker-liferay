# Docker image for liferay 6.2
A Liferay 6.2 ga6 container with separation of liferay-home and portal bundle files.

## Build image
In order to build the image execute this command in the terminal
```
docker build -f Dockerfile -t duffmck/docker-liferay:latest .
```

Inside the image you will find:
1. Liferay 6.2 ga6 bundle 
2. Liferay CE remote IDE connector
3. Liferay Marketplace portlet

## Start image
You can start it directly, it will use the hsqldb (not for production!)
```
docker run --rm -t -i -p 8080:8080 duffmck/docker-liferay
```
When you have the message "INFO: Server startup in xxx ms" you can open a browser and go to http://localhost:8080 (with boot2docker you must specify the ip, you can found it with # boot2docker ip)

## Link with Database
Acutally you can link it with mysql but it is easy to add one.

### Mysql
First start the mysql image
```
docker run --name lf-mysql -e MYSQL_ROOT_PASSWORD=mysecretpassword -e MYSQL_USER=lportal -e MYSQL_PASSWORD=lportal -e MYSQL_DATABASE=lportal -d mysql:5.6
```

Then start the liferay image with a link to the database and a volume mounted on a folder (on your host) for the liferay home directory
```
docker run --name liferay-6.2 --rm -it -p 8080:8080 --link lf-mysql:db_lep -v /tmp/liferay-home:/var/liferay-home -e DB_TYPE=MYSQL duffmck/docker-liferay
```
where:

1. __--name liferay-6.2__ -> is the name of container
2. __--link lf-mysql:db_lep__ -> is the link to container with MySQL: 
    1. `lf-mysql` is the name of container  
    2. `db_lep` is the reference available into the Liferay container (used in the MySQL connection string *jdbc:mysql://__db_lep__/lportal*)
3. __-v /tmp/liferay-home:/var/liferay-home__ -> is the volume for the liferay home directory: 
    1. `/tmp/liferay-home` is the absolute path of a directory on the host (your computer)
    2. `/var/liferay-home` is the path used by Liferay, __do not change this value__