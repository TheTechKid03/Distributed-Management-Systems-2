import ballerina/log;
import ballerinax/kafka;
import ballerinax/mongodb;

// Delivery request record type
type ExpressDeliveryRequest record {
    string customerName;
    string pickupLocation;
    string deliveryLocation;
    string preferredTime;
};

// MongoDB variables
mongodb:Database logisticsDB;
mongodb:Collection expressDeliveryCollection;

// Kafka producer configuration
kafka:ProducerConfiguration kafkaProducerConfig = {
    clientId: "express-delivery-service",
    acks: "all",
    retryCount: 3
};

// Create Kafka producer
kafka:Producer kafkaProducer = check new (kafka:DEFAULT_URL, kafkaProducerConfig);

// Create Kafka listener for incoming express delivery requests
listener kafka:Listener expressDeliveryListener = new (kafka:DEFAULT_URL, {
    groupId: "express-delivery-consumer",
    topics: ["Express-Delivery-Requests"]
});

// Initialize the MongoDB client and collection
service on expressDeliveryListener {
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

        // Retrieve the database and collection
        logisticsDB = check mongoClient->getDatabase("LogisticsDB");
        expressDeliveryCollection = check logisticsDB->getCollection("ExpressDeliveryRequests");
    }

    remote function onConsumerRecord(ExpressDeliveryRequest[] requests) returns error? {
        // Process the incoming express delivery requests
        foreach var request in requests {
            // Log the received request
            log:printInfo("Received express delivery request for " + request.customerName);

            // Convert JSON to a map
            map<anydata> doc = <map<anydata>> request.toJson();

            // Insert the request into the MongoDB collection
            check expressDeliveryCollection->insertOne(doc);
        }
    };
}
