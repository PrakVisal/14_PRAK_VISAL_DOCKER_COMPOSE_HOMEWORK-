# Stage 1: Build the application
FROM gradle:8.10-jdk17 AS builder

# Set working directory
WORKDIR /app

# Copy Gradle build files
COPY build.gradle settings.gradle ./
COPY gradlew ./
COPY gradle ./gradle

# Copy source code
COPY src ./src

# Build the application (creates JAR in build/libs)
RUN ./gradlew bootJar

# Stage 2: Create runtime image
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy the JAR from the builder stage
COPY --from=builder /app/build/libs/*.jar app.jar

# Expose the default Spring Boot port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]