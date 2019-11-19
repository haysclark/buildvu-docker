FROM tomcat:jdk11
RUN apt-get update && apt-get install -y libreoffice unzip --no-install-recommends && apt-get clean; \
 rm -rf /usr/local/tomcat/webapps/*; \
 mkdir -p /usr/local/docroot/output;
RUN \
 mkdir noto ;\
 wget -O noto/noto.zip https://noto-website-2.storage.googleapis.com/pkgs/Noto-hinted.zip; \
 unzip noto/noto.zip -d noto/ ; \
 mkdir -p /usr/share/fonts/opentype/noto/ ; \
 mv noto/*otf /usr/share/fonts/opentype/noto/ ; \
 chmod a+r /usr/share/fonts/opentype/noto/ ; \
 fc-cache -f -v; \
 rm -rf noto
RUN ["/bin/bash", "-c", "value=`cat /usr/local/tomcat/conf/server.xml` && echo \"${value//8080/80}\" >| /usr/local/tomcat/conf/server.xml"]
EXPOSE 80
ENV JAVA_OPTS='-Xms512m -Xmx1g'
ENTRYPOINT ["python3", "-u", "./entrypoint.py"]
COPY tomcat-users.xml ./conf
COPY web.xml ./conf
COPY https-server.xml ./conf
COPY https-web.xml ./conf
COPY setenv.sh ./bin
RUN chmod +x ./bin/setenv.sh
COPY entrypoint.py .
RUN chmod +x entrypoint.py
