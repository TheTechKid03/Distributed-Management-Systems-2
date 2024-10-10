# Use a base image with necessary tools (e.g., Ubuntu or Debian)
FROM ubuntu:20.04

# Install dependencies for Ballerina and curl
RUN apt-get update && apt-get install -y curl unzip

# Install Ballerina manually
RUN curl -Lo ballerina.zip https://dist.ballerina.io/downloads/2201.6.0/ballerina-linux-installer-x64-2201.6.0.zip \
    && unzip ballerina.zip -d /usr/local/ \
    && rm ballerina.zip

# Add Ballerina to the PATH
ENV PATH="/usr/local/ballerina-2201.6.0/bin:${PATH}"

# Ensure Ballerina is installed (this should already be part of the image)
RUN ballerina --version

# Use a base image that has Ballerina installed
FROM ballerina/ballerina:latest

# Set the working directory
WORKDIR /app

# Copy the Ballerina service files to the container
COPY . .

# Build the Ballerina service
RUN ballerina build main.bal

# Expose the port your service will run on
EXPOSE 8081

# Run the Ballerina service
CMD ["ballerina", "run", "main.bal"]
