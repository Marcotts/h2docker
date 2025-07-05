FROM openjdk:8-jdk-alpine
#FROM arm32v7/eclipse-temurin:11.0.24_8-jdk-focal

#Bloc1
USER root



ARG ZIP_FILE=install/*.zip
ARG JAR_FILE=install/*.jar
ARG DATABASE=install/bmdb*.*
COPY ${ZIP_FILE} /tmp/h2.zip
COPY ${DATABASE} /tmp/
COPY ${JAR_FILE} h2.jar

ENV H2DIR=/opt/h2 \
    H2VERS=2.2.224 \
    H2DATA=/opt/h2-data \
    H2CONF=/opt/h2-conf

ADD install/h2-start.sh /tmp/



RUN mkdir -p ${H2CONF} ${H2DATA}/data
RUN cp /tmp/bmdb*.* ${H2DATA}/data
RUN addgroup -g 1001 -S h2 && adduser -u 1001 -S h2 -G h2
RUN mkdir /logs && chown -R h2:h2  /logs
RUN unzip -q /tmp/h2.zip -d /opt/
RUN cp ${H2DIR}/bin/*.jar /opt/h2.jar
RUN rm /tmp/h2.zip
RUN mv /tmp/h2-start.sh ${H2DIR}/bin
RUN chmod 755 ${H2DIR}/bin/h2-start.sh  ${H2DIR}/bin/h2.sh
RUN chown -R h2:h2 /opt/h2*
RUN chmod +rx /opt/h2.jar

USER root

WORKDIR ${H2DIR}

VOLUME ${H2DATA}

EXPOSE 8084 9024

#CMD ["/opt/h2/bin/h2-start.sh"]

#ENTRYPOINT ["java", "-jar", "/opt/h2.jar", "org.h2.tools.Console", "-properties", "/opt/h2-conf", "-baseDir", "/opt/h2-data/data", "-webAllowOthers", "-tcpAllowOthers", "-tcpPort", "9024"]
ENTRYPOINT ["java", "-jar", "/opt/h2.jar", "-properties", "/opt/h2-conf", "-baseDir", "/opt/h2-data/data", "-webAllowOthers", "-tcpAllowOthers", "-tcpPort", "9024"]


#end