import ballerina/log;
import ballerinax/kafka;
import ballerinax/mongodb;

// Delivery request record type
type StandardDeliveryRequest record {
    string customerName;
    string pickupLocation;
    string deliveryLocation;
    string preferredTime;
};

// MongoDB variables
mongodb:Database logisticsDB;
mongodb:Collection standardDeliveryCollection;

// Kafka producer configuration
kafka:ProducerConfiguration kafkaProducerConfig = {
    clientId: "standard-delivery-service",
    acks: "all",
    retryCount: 3
};

// Create Kafka producer
kafka:Producer kafkaProducer = check new (kafka:DEFAULT_URL, kafkaProducerConfig);

// Create Kafka listener for incoming standard delivery requests
listener kafka:Listener standardDeliveryListener = new (kafka:DEFAULT_URL, {
    groupId: "standard-delivery-consumer",
    topics: ["Standard-Delivery-Requests"]
});

// Initialize the MongoDB client and collection
service on standardDeliveryListener {
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
                    database: "admin"
                }
            }
        });

        // Retrieve the database and collection
        logisticsDB = check mongoClient->getDatabase("LogisticsDB");
        standardDeliveryCollection = check logisticsDB->getCollection("StandardDeliveryRequests");
    }

    remote function onConsumerRecord(StandardDeliveryRequest[] requests) returns error? {
        // Process the incoming standard delivery requests
        foreach var request in requests {
            // Log the received request
            log:printInfo("Received standard delivery request for " + request.customerName);

            // Convert JSON to a map
            map<anydata> doc = <map<anydata>> request.toJson();

            // Insert the request into the MongoDB collection
            check standardDeliveryCollection->insertOne(doc);
        }
    };
}
