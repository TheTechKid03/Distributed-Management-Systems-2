import ballerinax/kafka;
import ballerina/log;
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
            serverSelectionTimeout: 5000
        }
    },
    databaseName: "EvoHealth"
};


mongodb:Client mongoClient = check new (mongoConfig);
string Patient_request_published = "Paitient Requests";
type Request_info record {
    string Request_id;
    string Patient_name;
    string Patient_last_name;
    int Patient_phone_number;
    int Patient_age;
    string Specialist_visiting;
    boolean isValid;
};


listener kafka:Listener orderListener = new (kafka:DEFAULT_URL, {
    groupId: "order-group-id",
    topics: [
        "Patient-Requests"
    ]
});


service on orderListener {

    remote function onConsumerRecord(Request_info[] requests) returns error? {
        // The set of requests received by the service are processed one by one.
        from Request_info Appointment in requests
        where Appointment.isValid
        do {
            log:printInfo(string `Received valid request for ${Appointment.Patient_name + " " + Appointment.Patient_last_name}`);
            map<json> doc = <map<json>>Appointment.toJson();
            check mongoClient->insert(doc, Patient_request_published);
        };
    }
}