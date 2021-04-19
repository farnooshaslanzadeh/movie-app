FROM maven:3.6.3-jdk-11-slim AS builder
WORKDIR /usr/src/app
COPY java/pom.xml /usr/src/app
RUN mvn dependency:resolve
COPY java /usr/src/app
RUN mvn -f /usr/src/app/pom.xml clean package
FROM openjdk:11-jre-slim
COPY --from=builder /usr/src/app/target/docker-0.0.1-SNAPSHOT.jar /usr/app/docker-0.0.1-SNAPSHOT.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","/usr/app/docker-0.0.1-SNAPSHOT.jar"]
