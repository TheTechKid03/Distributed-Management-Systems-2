import ballerinax/kafka;

// Define Kafka producer configuration
kafka:ProducerConfiguration producerConfig = {
    acks: "all",
    bootstrapServers: "localhost:9092", // Replace with your Kafka broker address
    clientId: "health-admin-client",
    keySerializer: "org.apache.kafka.common.serialization.StringSerializer",
    valueSerializer: "org.apache.kafka.common.serialization.StringSerializer"
};

kafka:Producer kafkaProducer = check new (kafka:DEFAULT_URL, producerConfig);

function main(string... args) {
    // Send a request to the Health Admin Service
    string requestMessage = "Your request message here";
    var result = kafkaProducer->send("Patient-Requests", requestMessage);

    match result {
        kafka:RecordMetadata recordMetadata => {
            io:println("Request sent successfully. Offset: " + recordMetadata.offset);
        }
        error e => {
            io:println("Error sending request: " + e.toString());
        }
    }
}