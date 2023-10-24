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
string Gynaecology_collection = "Gynaecology Appointments";

listener kafka:Listener Gynaecology_service = new (kafka:DEFAULT_URL, {
    groupId: "Gynaecology-Appointment-consumer",
    topics: [
        "Appointment-Details"
    ]
});

service on Gynaecology_service {
    remote function onConsumerRecord(AppointmentDetails[] appointments) returns error? {
        // Process the patient appointment requests for Gynaecology

        foreach var Appointment in appointments {
            // Log the received request
            log:printInfo("Received Gynaecology appointment request for " + Appointment.Patient_full_name);

            // Insert the appointment into the Gynaecology MongoDB collection
            map<json> doc = <map<json>>Appointment.toJson();
            check MongoDB->insert(doc, Gynaecology_collection);
        }
    };
}