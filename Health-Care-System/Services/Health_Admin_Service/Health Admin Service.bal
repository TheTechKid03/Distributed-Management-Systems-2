import ballerina/http;
import ballerina/log;
import ballerina/io;
import ballerinax/kafka;
import ballerinax/mongodb;

type HealthAdminRequest record {
    string Patient_first_name;
    string Patient_last_name;
    string Patient_phone_number;
    int Patient_age;
    string Specialist_visiting;
    string Availability;
};

type HealthAdminResponse record {
    string Request_id;
    string Response_message;
};

type AppointmentDetails record {
    string Request_id;
    string Specialist_visiting;
    string Appointment_date;
    string Patient_full_name;
    string Patient_phone_number;
};

mongodb:ConnectionConfig mongoConfig = {
    connection: {
        host: "localhost",
        port: 27017,
        auth: {
            username: "",
            password: ""
        },
        options: {
            sslEnabled: false,
            serverSelectionTimeout: 5000
        }
    },
    databaseName: "EvoHealth"
};

mongodb:Client MongoDB = check new (mongoConfig);
string Dermatology_collection = "Dermatology Requests";
string Gastroenterology_collection = "Gastroenterology Requests";
string Gynaecology_collection = "Gynaecology Requests";
string Appointments_collection = "Appointments";

// Define Kafka producer configuration
kafka:ProducerConfiguration kafkaProducerConfig = {
    clientId: "health-admin-service",
    acks: "all",
    retryCount: 3
};

kafka:Producer kafkaProducer = check new (kafka:DEFAULT_URL, kafkaProducerConfig);

listener kafka:Listener Admin_service = new (kafka:DEFAULT_URL, {
    groupId: "Patient-data-consumer",
    topics: [
        "Patient-Requests",
        "Appointment-Details",
        "Specialist-Response"
    ]
});

service on Admin_service {
    remote function onConsumerRecord(HealthAdminRequest[] requests) returns error? {

        // The set of requests received by the service are processed one by one.
        from HealthAdminRequest Appointment in requests
        where Appointment.Specialist_visiting === "Dermatology"
        do {
            io:println(string `Received valid request for ${Appointment.Patient_first_name + " " + Appointment.Patient_last_name}`);
            map<json> doc = <map<json>>Appointment.toJson();
            check MongoDB->insert(doc, Dermatology_collection);
        };

        from HealthAdminRequest Appointment in requests
        where Appointment.Specialist_visiting === "Gastroenterology"
        do {
            io:println(string `Received valid request for ${Appointment.Patient_first_name + " " + Appointment.Patient_last_name}`);
            map<json> doc = <map<json>>Appointment.toJson();
            check MongoDB->insert(doc, Gastroenterology_collection);
        };

        from HealthAdminRequest Appointment in requests
        where Appointment.Specialist_visiting === "Gynaecology"
        do {
            io:println(string `Received valid request for ${Appointment.Patient_first_name + " " + Appointment.Patient_last_name}`);
            map<json> doc = <map<json>>Appointment.toJson();
            check MongoDB->insert(doc, Gynaecology_collection);
        };
    };
}



service /Health_Admin_Service on new http:Listener(8080) {

resource function post addAppointment(AppointmentDetails[] appointments) returns string|error? {
       
    foreach var Appointment in appointments {
            // Log the received request
            log:printInfo("Received valid request for " + Appointment.Patient_full_name);

            // Insert the appointment into MongoDB
            map<json> doc = <map<json>>Appointment.toJson();
            var insertResult = MongoDB->insert(doc, Gastroenterology_collection);
            if (insertResult is error) {
                // Log and return the error
                log:printError("Failed to insert appointment into MongoDB: " + insertResult.toString());
                return insertResult;
            }
    }
    return "Appointment(s) added successfully.";
}
}