// Import required modules
import ballerinax/kafka;
import ballerinax/mongodb;
import ballerina/log;


// Define the record type for AppointmentDetails
type AppointmentDetails record {
    string Request_id;
    string Specialist_visiting;
    string Appointment_date;
    string Patient_full_name;
    string Patient_phone_number;
};


// Configure the MongoDB connection
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


// Create a MongoDB client
mongodb:Client MongoDB = check new (mongoConfig);


// Define the MongoDB collection name for Dermatology appointments
string Dermatology_collection = "Dermatology Appointments";



// Create a Kafka listener for Dermatology appointments
listener kafka:Listener Dermatology_service = new (kafka:DEFAULT_URL, {
    groupId: "Dermatology-Appointment-consumer",
    topics: [
        "Appointment-Details"
    ]
});



// Define a service to handle Dermatology appointment requests
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