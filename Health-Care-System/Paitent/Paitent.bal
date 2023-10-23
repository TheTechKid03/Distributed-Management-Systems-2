import ballerina/io;
import ballerinax/kafka;
import ballerina/uuid;


type Request_info record {
    string Request_id;
    string Patient_name;
    string Patient_last_name;
    int Patient_age;
    int Patient_phone_number;
    string Specialist_visiting;
    boolean isValid;
};


public function main() returns error? {
    final kafka:Producer producer;
    producer = check new (kafka:DEFAULT_URL);
    kafka:Consumer orderConsumer = check new (kafka:DEFAULT_URL, {
        groupId: "order-group-id",
        topics: "Patient-Requests"
    });


 io:println("Which option would you like to select?");
 io:println("1. Send a Request/Appointment");
 io:println("2. View all Requests/Appointments");


string option = io:readln("Select Option: ");
    match option {
        "1" => {
            check Add_a_request(producer);
        }
        "2" => {
            check View_my_requests(orderConsumer);
        }
        _ => {
            error? mainResult = main();
            if mainResult is error {
            io:println("Invalid Option!");
            check main();
            }
        }
    }
}


// Function to create customer order or placing an order.
function Add_a_request(kafka:Producer Patient_producer) returns error? {
    Request_info request = {isValid: true, Request_id: "", Patient_name: "", Patient_last_name: "", Patient_age: 0, Patient_phone_number: 0, Specialist_visiting: ""};

    request.Request_id = uuid:createType1AsString();
    request.Patient_name = io:readln("Enter Patient First Name: ");
    request.Patient_last_name = io:readln("Enter Patient Last Name: ");
    request.Patient_age = check int:fromString(io:readln("Enter Patient Age: "));
    request.Patient_phone_number = check int:fromString(io:readln("Enter Your Phone Number: +264"));
    request.Specialist_visiting = io:readln("Enter The Specialist you want to visit: ");

    kafka:Error? send = Patient_producer->send({
        topic: "Patient-Requests",
        value: request
    });

    if send is kafka:Error {
        io:println(send.message());
    }

    check main();
}


function View_my_requests(kafka:Consumer consumer) returns error? {
    Request_info[] requests = check consumer->pollPayload(60);
    string Request = io:readln("Enter Name & Surname");

    from var Appointment in requests
    where (Appointment.Request_id + Appointment.Patient_name) === Request
    do {
        io:println(requests);
    };
    check main();
}

