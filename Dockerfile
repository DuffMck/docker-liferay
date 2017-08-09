# Liferay 6.2
#
# VERSION 0.0.1
#

FROM openjdk:7-jre-alpine

MAINTAINER Davide Bonomelli <davide.bonomelli@gmail.com>

# install curl, unzip
RUN apk --no-cache add curl 
RUN apk --no-cache add unzip

# install liferay
RUN curl -O -s -k -L -C - http://downloads.sourceforge.net/project/lportal/Liferay%20Portal/6.2.5%20GA6/liferay-portal-tomcat-6.2-ce-ga6-20160112152609836.zip \
	&& unzip liferay-portal-tomcat-6.2-ce-ga6-20160112152609836.zip -d /opt \
	&& rm liferay-portal-tomcat-6.2-ce-ga6-20160112152609836.zip

# add config for external properties (in case MySQL)
RUN /bin/echo -e '\nCATALINA_OPTS="$CATALINA_OPTS -Dexternal-properties=portal-bd-${DB_TYPE}.properties"' >> /opt/liferay-portal-6.2-ce-ga6/tomcat-7.0.62/bin/setenv.sh

# add configuration liferay file
ADD properties/portal-bundle.properties /opt/liferay-portal-6.2-ce-ga6/portal-bundle.properties
ADD properties/portal-bd-MYSQL.properties /opt/liferay-portal-6.2-ce-ga6/portal-bd-MYSQL.properties

# add basic portlets to liferay
ADD basic/Liferay_CE_Remote_IDE_Connector.lpkg /opt/liferay-portal-6.2-ce-ga6/deploy/Liferay_CE_Remote_IDE_Connector.lpkg
ADD basic/Liferay_Marketplace.lpkg /opt/liferay-portal-6.2-ce-ga6/deploy/Liferay_Marketplace.lpkg

# volumes
VOLUME ["/var/liferay-home", "/opt/liferay-portal-6.2-ce-ga6/"]

# Ports
EXPOSE 8080

# EXEC
CMD ["run"]
ENTRYPOINT ["/opt/liferay-portal-6.2-ce-ga6/tomcat-7.0.62/bin/catalina.sh"]
