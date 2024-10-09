# Use a base image that has Ballerina installed
FROM ballerina/ballerina:latest

# Set the working directory
WORKDIR /app

# Copy the Ballerina service files to the container
COPY . .

# Build the Ballerina service
RUN ballerina build main.bal

# Expose the port your service will run on
EXPOSE 8080

# Run the Ballerina service
CMD ["ballerina", "run", "main.bal"]
