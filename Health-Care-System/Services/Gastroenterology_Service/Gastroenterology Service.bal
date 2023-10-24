//import ballerina/log;
//import ballerina/io;
import ballerinax/kafka;
import ballerinax/mongodb;


type Request_info record {
    string Request_id;
    string Patient_name;
    string Patient_last_name;
    int Patient_phone_number;
    int Patient_age;
    string Specialist_visiting;
    boolean isValid;
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
string Patient_collection = "Patient Requests";
listener kafka:Listener Admin_service = new (kafka:DEFAULT_URL, {
    groupId: "Patient-data-consumer",
    topics: [
        "Patient-Requests",
        "Appointment-Details",
        "Specialist-Response"
    ]
});
