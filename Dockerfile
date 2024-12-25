# Use a stable base image with OpenJDK pre-installed
FROM eclipse-temurin:17-jdk-focal

# Set the working directory
WORKDIR /app

# Copy the application code to the container
COPY . /app

# Grant executable permissions to the Maven wrapper
RUN chmod +x ./mvnw

# Download dependencies to cache them
RUN ./mvnw dependency:go-offline

# Expose the application port
EXPOSE 8080

# Run the Spring Boot application using Maven
CMD ["./mvnw", "spring-boot:run"]
