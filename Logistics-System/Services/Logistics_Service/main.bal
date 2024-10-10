import ballerina/http;
import ballerina/kafka;
import ballerina/log;

service /logistics on new http:Listener(8080) {
    
    private final kafka:Producer producer;

    function init() returns error? {
        // Kafka Producer configuration
        kafka:ProducerConfiguration producerConfig = {
            bootstrapServers: "localhost:9092"
        };
        self.producer = check new(producerConfig);
    }

    resource function post scheduleDelivery(http:Caller caller, http:Request req) returns error? {
        json requestPayload = check req.getJsonPayload();
        
        // Assuming the requestPayload includes `deliveryType`
        string deliveryType = requestPayload.deliveryType.toString();
        string topic;
        
        // Route to appropriate Kafka topic based on delivery type
        if deliveryType == "standard" {
            topic = "standard-delivery";
        } else if deliveryType == "express" {
            topic = "express-delivery";
        } else if deliveryType == "international" {
            topic = "international-delivery";
        } else {
            check caller->respond("Invalid delivery type");
            return;
        }

        // Publish the request to the respective Kafka topic
        check self.producer->send({
            topic: topic,
            value: requestPayload.toJsonString()
        });

        // Respond to the client
        check caller->respond("Delivery request has been forwarded to the " + deliveryType + " service.");
    }
}
