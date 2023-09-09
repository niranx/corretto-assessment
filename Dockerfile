FROM maven:3.8-openjdk-11-slim AS build
WORKDIR /app

COPY ./pom.xml ./
RUN ["/usr/local/bin/mvn-entrypoint.sh", "mvn", "verify", "clean", "--fail-never"]

COPY . ./
RUN mvn assembly:assembly -DdescriptorId=jar-with-dependencies

FROM gcr.io/distroless/java11
WORKDIR /app

COPY --from=build /app/target/sample-app-1.0-jar-with-dependencies.jar /app/sample-app-1.0-jar-with-dependencies.jar

ENV PORT=8080
ENTRYPOINT ["java","-jar","/app/sample-app-1.0-jar-with-dependencies.jar"]
