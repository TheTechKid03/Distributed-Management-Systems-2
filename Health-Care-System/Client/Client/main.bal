import ballerinax/kafka;
import ballerina/io;


kafka:ProducerConfiguration producerConfiguration = {
    clientId: "basic-producer",
    acks: "all",
    retryCount: 3
};

kafka:Producer kafkaProducer = check new (kafka:DEFAULT_URL, producerConfiguration);

public function main(string... args) {
    // Prepare a patient request
    map<json> patientRequest = {
        "Patient_first_name": "John",
        "Patient_last_name": "Doe",
        "Patient_phone_number": "1234567890",
        "Patient_age": 35,
        "Specialist_visiting": "Dermatology",
        "Availability": "Monday"
    };


    // Send the patient request to Kafka
    var result = kafkaProducer->send({ topic: "test-kafka-topic",
                            value: patientRequest });
    
    if (result is error) {
        io:println("Error sending patient request: " + result.toString());
    } else {
        io:println("Patient request sent successfully!");
    }
}