FROM openjdk:8-jdk-alpine

USER root

ARG ZIP_FILE=install/*.zip
ARG DATABASE=install/test*.*
COPY ${ZIP_FILE} /tmp/h2.zip
COPY ${DATABASE} /tmp/

ENV H2DIR=/opt/h2 \
    H2VERS=2.2.224 \
    H2DATA=/opt/h2-data \
    H2CONF=/opt/h2-conf

ADD install/h2-start.sh /tmp/

#RUN addgroup -g 1001 -S appuser && adduser -u 1001 -S appuser -G appuser
RUN mkdir -p ${H2CONF} ${H2DATA}/data
RUN cp /tmp/test*.* ${H2DATA}/data
RUN addgroup -g 1001 -S h2 && adduser -u 1001 -S h2 -G h2
RUN mkdir /logs && chown -R h2:h2  /logs
RUN unzip -q /tmp/h2.zip -d /opt/
RUN rm /tmp/h2.zip
RUN mv /tmp/h2-start.sh ${H2DIR}/bin
RUN chmod 755 ${H2DIR}/bin/h2-start.sh  ${H2DIR}/bin/h2.sh
RUN chown -R h2:h2 /opt/h2*

USER h2

WORKDIR ${H2DIR}

VOLUME ${H2DATA}

EXPOSE 8084 9024

CMD ["/opt/h2/bin/h2-start.sh"]


#end