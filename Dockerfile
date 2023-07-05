FROM maven:3.2.3-jdk-7u65 AS maven_build

COPY pom.xml /tmp/

COPY src /tmp/src/

WORKDIR /tmp/

RUN mvn package

#pull base image

FROM openjdk

EXPOSE 8080

#copy hello world to docker image from builder image
COPY --from=maven_build /tmp/target/sample-1.0.3.jar /data/sample-1.0.3.jar

#default command
CMD ["java", "-jar", "/data/sample-1.0.3.jar"]
