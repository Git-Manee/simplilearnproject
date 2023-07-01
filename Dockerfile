# Use a base image with Java and Maven installed
FROM maven:3.6.3-openjdk-11-slim AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the POM file to the container
COPY pom.xml .

# Download the project dependencies
RUN mvn dependency:go-offline -B

# Copy the project source code to the container
COPY src/ /app/src/

# Build the application
RUN mvn package -DskipTests

# Use a lightweight base image with Java installed
FROM openjdk:11-jre-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the built application from the previous stage
COPY --from=build /app/target/mvn-hello-world.war .

# Expose the port on which the application will run (adjust if needed)
EXPOSE 8080

# Set the entry point command to run the application
CMD ["java", "-jar", "mvn-hello-world.war"]
