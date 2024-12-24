# Stage 1: Build Stage
FROM ubuntu:20.04 AS build

# Install OpenJDK 23, Maven, and other dependencies
RUN apt-get update && apt-get install -y \
    openjdk-23-jdk maven wget curl tar unzip && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables for OpenJDK 23
ENV JAVA_HOME=/usr/lib/jvm/java-23-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Verify Java version
RUN java --version

# Set the working directory
WORKDIR /app

# Copy the project files to the container
COPY . /app

# Build the Spring Boot application using Maven, skipping tests
RUN mvn clean package -DskipTests

# Stage 2: Runtime Stage
FROM ubuntu:20.04

# Install runtime dependencies (curl, wget, etc.)
RUN apt-get update && apt-get install -y \
    wget curl tar unzip && \
    rm -rf /var/lib/apt/lists/*

# Copy OpenJDK 23 from the build stage
COPY --from=build /usr/lib/jvm/java-23-openjdk-amd64 /usr/lib/jvm/java-23-openjdk-amd64

# Set Java environment variables for runtime
ENV JAVA_HOME=/usr/lib/jvm/java-23-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Verify Java version in the runtime stage
RUN java --version

# Copy the built JAR file from the build stage
COPY --from=build /app/target/*.jar /app/app.jar

# Expose the application port (default Spring Boot port 8080, can change to 8081 or others as needed)
EXPOSE 8081

# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
