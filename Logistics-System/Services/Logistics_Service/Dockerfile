# Use the official Ballerina image as the base
FROM ballerina/ballerina:latest

# Set the working directory
WORKDIR /app

# Copy the Ballerina service files into the container
COPY . .

# Expose the port your service will run on
EXPOSE 8080

# Command to run your Ballerina service
CMD ["ballerina", "run", "main.bal"]
