import ballerina/http;
import ballerina/log;
import ballerina/io;

// Delivery request record type
type DeliveryRequest record {
    string customerName;
    string deliveryType; // standard, express, international
    string pickupLocation;
    string deliveryLocation;
    string preferredTime;
};

// Create HTTP client
http:Client logisticsClient = check new ("http://localhost:8080/logistics");

// Function to read input from terminal
function readInput(string prompt) returns string {
    io:print(prompt);
    return io:readln();
}

// Main function
public function main() returns error? {
    // Create a new delivery request
    DeliveryRequest request = {
        customerName: "",
        deliveryType: "",
        pickupLocation: "",
        deliveryLocation: "",
        preferredTime: ""
    };

    // Collect details for the delivery request
    request.customerName = readInput("Enter customer name: ");
    request.deliveryType = readInput("Enter delivery type (standard, express, international): ");
    request.pickupLocation = readInput("Enter pickup location: ");
    request.deliveryLocation = readInput("Enter delivery location: ");
    request.preferredTime = readInput("Enter preferred time: ");

    // Send the delivery request to the logistics service
    var response = logisticsClient->post("/scheduleDelivery", [request], targetType = http:Response);

    // Check the response
    if (response is http:Response) {
        var responseBody = response.getJsonPayload();
        if (responseBody is json) {
            log:printInfo("Response: " + responseBody.toString());
        } else {
            log:printError("Failed to retrieve JSON payload.");
        }
    } else {
        log:printError("Error in sending request: " + response.toString());
    }
}
