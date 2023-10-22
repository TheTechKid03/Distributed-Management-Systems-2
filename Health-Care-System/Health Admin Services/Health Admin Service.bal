import ballerina/io;
//import ballerina/log
import ballerinax/kafka;
import ballerinax/mongodb;

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
            serverSelectionTimeout: 50000
        }
    },
    databaseName: "EvoHealth"
};

mongodb:Client mongoClient = check new (mongoConfig);
string Patient_request_published = "Patient Requests";

type Request_info record {
    string Request_id;
    string Patient_name;
    string Patient_last_name;
    int Patient_phone_number;
    int Patient_age;
    string Specialist_visiting;
    boolean isValid;
};

listener kafka:Listener Admin_service = new (kafka:DEFAULT_URL, {
    groupId: "Patient data consumer",
    topics: [
        "Patient-Requests",
        "Appointment-Details",
        "Specialist-Response"
    ]
});

service on Admin_service {
    remote function onConsumerRecord(Request_info[] requests) returns error? {
        // The set of requests received by the service are processed one by one.
        from Request_info Appointment in requests
        where Appointment.Specialist_visiting === "Dermatology"
        do {
            io:println(string `Received valid request for ${Appointment.Patient_name + " " + Appointment.Patient_last_name}`);
            map<json> Request_1 = <map<json>>Appointment.toJson();
            check mongoClient->insert(Request_1, Patient_request_published);
        };


        from Request_info Appointment in requests
        where Appointment.Specialist_visiting === "Gastroenterology"
        do {
            io:println(string `Received valid request for ${Appointment.Patient_name + " " + Appointment.Patient_last_name}`);
            map<json> Request_2 = <map<json>>Appointment.toJson();
            check mongoClient->insert(Request_2, Patient_request_published);
        };


        from Request_info Appointment in requests
        where Appointment.Specialist_visiting === " Gynaecology"
        do {
            io:println(string `Received valid request for ${Appointment.Patient_name + " " + Appointment.Patient_last_name}`);
            map<json> Request_3 = <map<json>>Appointment.toJson();
            check mongoClient->insert(Request_3, Patient_request_published);
        };

    };
}
