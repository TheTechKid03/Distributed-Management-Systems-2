import ballerina/log;
import ballerinax/kafka;
import ballerinax/mongodb;

// Delivery request record type for international deliveries
type InternationalDeliveryRequest record {
    string customerName;
    string pickupLocation;
    string deliveryLocation;
    string preferredTime;
    string customsInfo; // Additional field for customs information
};

// MongoDB variables
mongodb:Database logisticsDB;
mongodb:Collection internationalDeliveryCollection;

// Kafka producer configuration
kafka:ProducerConfiguration kafkaProducerConfig = {
    clientId: "international-delivery-service",
    acks: "all",
    retryCount: 3
};

// Create Kafka producer
kafka:Producer kafkaProducer = check new (kafka:DEFAULT_URL, kafkaProducerConfig);

// Create Kafka listener for incoming international delivery requests
listener kafka:Listener internationalDeliveryListener = new (kafka:DEFAULT_URL, {
    groupId: "international-delivery-consumer",
    topics: ["International-Delivery-Requests"]
});

// Initialize the MongoDB client and collection
service on internationalDeliveryListener {
    function init() returns error? {
        // Initialize the MongoDB client
        mongodb:Client mongoClient = check new ({
            connection: {
                serverAddress: {
                    host: "localhost",
                    port: 27017
                },
                auth: <mongodb:ScramSha256AuthCredential>{
                    username: "root",
                    password: "rootpassword",
                    database: "admin"
                }
            }
        });

        // Retrieve the database and collection
        logisticsDB = check mongoClient->getDatabase("LogisticsDB");
        internationalDeliveryCollection = check logisticsDB->getCollection("InternationalDeliveryRequests");
    }

    remote function onConsumerRecord(InternationalDeliveryRequest[] requests) returns error? {
        // Process the incoming international delivery requests
        foreach var request in requests {
            // Log the received request
            log:printInfo("Received international delivery request for " + request.customerName);

            // Convert JSON to a map
            map<anydata> doc = <map<anydata>> request.toJson();

            // Insert the request into the MongoDB collection
            check internationalDeliveryCollection->insertOne(doc);
        }
    };
}
