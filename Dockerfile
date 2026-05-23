FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /workspace

COPY pom.xml ./
RUN mvn -B -q -DskipTests dependency:go-offline

COPY src ./src
RUN mvn -B -q -DskipTests package && \
    WAR_PATH="$(ls target/*.war | grep -v '\.original$' | head -n 1)" && \
    cp "${WAR_PATH}" /tmp/app.war

FROM tomcat:10.1-jdk17-temurin
WORKDIR /usr/local/tomcat

RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /tmp/app.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

ENV JAVA_OPTS=""
ENTRYPOINT ["sh", "-c", "if [ -n \"${DATABASE_URL}\" ] && [ -z \"${SPRING_DATASOURCE_URL}\" ]; then DB_URI=\"${DATABASE_URL#postgresql://}\"; DB_URI=\"${DB_URI#postgres://}\"; DB_HOST_AND_PATH=\"${DB_URI#*@}\"; if [ \"${DB_HOST_AND_PATH}\" = \"${DB_URI}\" ]; then DB_HOST_AND_PATH=\"${DB_URI}\"; fi; DB_HOST_PORT=\"${DB_HOST_AND_PATH%%/*}\"; DB_PATH=\"${DB_HOST_AND_PATH#*/}\"; if [ \"${DB_PATH}\" = \"${DB_HOST_AND_PATH}\" ]; then DB_PATH=\"\"; fi; if [ -n \"${DB_PATH}\" ]; then export SPRING_DATASOURCE_URL=\"jdbc:postgresql://${DB_HOST_PORT}/${DB_PATH}\"; else export SPRING_DATASOURCE_URL=\"jdbc:postgresql://${DB_HOST_PORT}\"; fi; fi; if [ -n \"${DATABASE_URL}\" ] && [ -z \"${SPRING_DATASOURCE_DRIVER}\" ]; then export SPRING_DATASOURCE_DRIVER=\"org.postgresql.Driver\"; fi; if [ -n \"${PORT}\" ]; then sed -i \"s/Connector port=\\\"8080\\\"/Connector port=\\\"${PORT}\\\"/\" /usr/local/tomcat/conf/server.xml; fi; export CATALINA_OPTS=\"${JAVA_OPTS}\"; catalina.sh run"]
