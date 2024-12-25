# Use an official Ubuntu image as the base image
FROM ubuntu:20.04

# Install dependencies, OpenJDK 23, and Maven
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    tar \
    unzip \
    maven && \
    wget -O /tmp/openjdk-23.tar.gz https://download.java.net/openjdk/jdk23/ri/openjdk-23_linux-x64_bin.tar.gz && \
    if [ "$(sha256sum /tmp/openjdk-23.tar.gz | awk '{print $1}')" = "<expected-sha256-hash>" ]; then \
        tar -xz -C /usr/lib/jvm -f /tmp/openjdk-23.tar.gz && \
        mv /usr/lib/jvm/jdk-23 /usr/lib/jvm/java-23-openjdk; \
    else \
        echo "Checksum validation failed!" && exit 1; \
    fi && \
    rm -f /tmp/openjdk-23.tar.gz && \
    rm -rf /var/lib/apt/lists/*

# Set the JAVA_HOME environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-23-openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

# Set the working directory in the container
WORKDIR /src

# Copy the current directory contents into the container at /src
COPY . /src

# Build the application using Maven
RUN mvn clean package

# Expose port 8080 for the application
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "target/your-application-name.jar"]
