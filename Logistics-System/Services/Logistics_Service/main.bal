import ballerina/http;
import ballerina/log;
import ballerinax/kafka;
import ballerinax/mongodb;

// Delivery request record type
type DeliveryRequest record {
    string customerName;
    string deliveryType; // standard, express, international
    string pickupLocation;
    string deliveryLocation;
    string preferredTime;
};

// MongoDB variables
mongodb:Database logisticsDB;
mongodb:Collection standardDeliveryCollection;
mongodb:Collection expressDeliveryCollection;
mongodb:Collection internationalDeliveryCollection;

// Kafka producer configuration
kafka:ProducerConfiguration kafkaProducerConfig = {
    clientId: "logistics-service",
    acks: "all",
    retryCount: 3
};

// Create Kafka producer
kafka:Producer kafkaProducer = check new (kafka:DEFAULT_URL, kafkaProducerConfig);

// Create Kafka listener for incoming delivery requests
listener kafka:Listener logisticsListener = new (kafka:DEFAULT_URL, {
    groupId: "logistics-data-consumer",
    topics: [
        "Delivery-Requests",
        "Delivery-Responses"
    ]
});

// Initialize the MongoDB client and collections
service on logisticsListener {
    function init() returns error? {
        // Initialize the MongoDB client
        mongodb:Client mongoClient = check new ({
            connection: {
                serverAddress: {
                    host: "localhost",
                    port: 27017
                },
                auth: <mongodb:ScramSha256AuthCredential>{
                    username: "<username>",
                    password: "<password>",
                    database: "logisticsDB"
                }
            }
        });

        // Retrieve the database and collections
        logisticsDB = check mongoClient->getDatabase("LogisticsDB");
        standardDeliveryCollection = check logisticsDB->getCollection("StandardDeliveryRequests");
        expressDeliveryCollection = check logisticsDB->getCollection("ExpressDeliveryRequests");
        internationalDeliveryCollection = check logisticsDB->getCollection("InternationalDeliveryRequests");
    }

    remote function onConsumerRecord(DeliveryRequest[] requests) returns error? {
        // Process the incoming delivery requests
        foreach var request in requests {
            // Log the received request
            log:printInfo("Received delivery request for " + request.customerName);

            // Convert JSON to a map
            map<anydata> doc = <map<anydata>> request.toJson();

            // Insert the request into the appropriate MongoDB collection based on delivery type
            if request.deliveryType == "standard" {
                check standardDeliveryCollection->insertOne(doc);
            } else if request.deliveryType == "express" {
                check expressDeliveryCollection->insertOne(doc);
            } else if request.deliveryType == "international" {
                check internationalDeliveryCollection->insertOne(doc);
            } else {
                log:printError("Invalid delivery type: " + request.deliveryType);
            }
        }
    };
}

// HTTP service to accept and add new delivery requests
service /logistics on new http:Listener(8080) {

    // Resource function to accept new delivery requests
    resource function post scheduleDelivery(DeliveryRequest[] deliveries) returns string|error? {
        foreach var delivery in deliveries {
            // Log the request
            log:printInfo("Scheduling delivery for " + delivery.customerName);

            // Convert JSON to a map
            map<anydata> doc = <map<anydata>> delivery.toJson();

            // Insert the delivery request into MongoDB
            if delivery.deliveryType == "standard" {
                check standardDeliveryCollection->insertOne(doc);
            } else if delivery.deliveryType == "express" {
                check expressDeliveryCollection->insertOne(doc);
            } else if delivery.deliveryType == "international" {
                check internationalDeliveryCollection->insertOne(doc);
            } else {
                log:printError("Invalid delivery type: " + delivery.deliveryType);
                return "Invalid delivery type";
            }

            // Initialize the topic based on the delivery type
            string topic = "";
            if delivery.deliveryType == "standard" {
                topic = "Standard-Delivery-Requests";
            } else if delivery.deliveryType == "express" {
                topic = "Express-Delivery-Requests";
            } else if delivery.deliveryType == "international" {
                topic = "International-Delivery-Requests";
            } else {
                log:printError("Invalid delivery type: " + delivery.deliveryType);
                return "Invalid delivery type";
            }

            // Publish the request to Kafka
            check kafkaProducer->send({
                topic: topic,
                value: delivery.toJsonString()
            });

            log:printInfo("Delivery request for " + delivery.customerName + " forwarded to " + topic);
        }

        return "Delivery request(s) scheduled successfully.";
    }
}
