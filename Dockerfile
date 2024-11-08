FROM maven:3.8.7 as build
COPY . .
RUN mvn -B clean package -DskipTests
FROM openjdk:17
COPY --from=build target/*.jar terraf.jar
# ENV SPRING_PROFILES_ACTIVE=$(PROFILE)
ENTRYPOINT ["java", "-jar", "-Dserver.port=8082", "terraf.jar"]

