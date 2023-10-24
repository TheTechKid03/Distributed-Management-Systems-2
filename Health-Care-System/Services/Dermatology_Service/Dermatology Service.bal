import ballerinax/kafka;
import ballerinax/mongodb;
import ballerina/log;

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
string Dermatology_collection = "Dermatology Appointments";

listener kafka:Listener Dermatology_service = new (kafka:DEFAULT_URL, {
    groupId: "Dermatology-Appointment-consumer",
    topics: [
        "Appointment-Details"
    ]
});

service on Dermatology_service {
    remote function onConsumerRecord(AppointmentDetails[] appointments) returns error? {
        // Process the patient appointment requests for Dermatology

        foreach var Appointment in appointments {
            // Log the received request
            log:printInfo("Received Dermatology appointment request for " + Appointment.Patient_full_name);

            // Insert the appointment into the Dermatology MongoDB collection
            map<json> doc = <map<json>>Appointment.toJson();
            check MongoDB->insert(doc, Dermatology_collection);
        }
    };
}