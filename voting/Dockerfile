# Stage 1: Build the Spring Boot application
# Using a Maven image with Temurin (OpenJDK) and Alpine Linux for a relatively small build environment.
FROM maven:3-eclipse-temurin-19-alpine as build

# Set the working directory inside the container for the build process
WORKDIR /app

# Copy only the project's POM file first. This allows Docker to cache the dependency download step.
# If pom.xml doesn't change, this layer and the next (mvn dependency:go-offline) will be cached.
COPY pom.xml ./

# Download project dependencies. This step is cached as long as pom.xml doesn't change.
# Using 'dependency:go-offline' ensures all dependencies are downloaded before copying source.
RUN mvn dependency:go-offline

# Copy the rest of the project source code
COPY src ./src

# Build the application using Maven.
# '-DskipTests' is good for faster image builds, assuming tests are run elsewhere.
RUN mvn package -DskipTests

# Stage 2: Create a smaller image for production runtime
# Using a JRE-only Alpine image for a minimal runtime environment.
# 'openjdk:19-alpine' typically provides just the JRE, which is sufficient for running a JAR.
FROM openjdk:19-alpine

# Set the working directory inside the container for the application
WORKDIR /app

# Copy only the built JAR file from the 'build' stage into the final image.
# This prevents copying any source code, build tools, or temporary files from the build stage.
COPY --from=build /app/target/voting-0.0.1-SNAPSHOT.jar app.jar

# Expose port 8080 to indicate that the application listens on this port.
# This is for documentation and container linking; actual port mapping is done with 'docker run -p'.
EXPOSE 8080

# Define the command to run the Spring Boot application when the container starts.
# 'java -jar app.jar' is the standard way to run a Spring Boot executable JAR.
CMD ["java", "-jar", "app.jar"]
