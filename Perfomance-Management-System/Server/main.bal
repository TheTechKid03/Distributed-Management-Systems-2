import ballerina/graphql;
// import ballerina/io;
import ballerinax/mongodb;

//when using mongo db you dont need to pass the ID, coz mongo db generates one for u
type DepartmentObjectives record {
    string departmentName;
    string objectiveName;
    string objectiveDescription;
    string ObjectiveId;

};

type User record {
    string username;
    string password;
};

// Definning the connection configurations to mongo db

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
    databaseName: "FCIManagementSystem"

};
mongodb:Client db = check new (mongoConfig);

//collections below
configurable string ObjectivesCollection = "DepartmentObjectives";
configurable string UsersCollection = "Users";

service /FCIManagemetSystem on new graphql:Listener(9090) {
    //CREATE DepartmentObjeective
    remote function CreateObjectives(DepartmentObjectives newDepartmentObjectives) returns (string|error) {
        //recieve the Department Objective record from client,convert the record to MapJson and store it in a database 

        map<json> myDoc = <map<json>>newDepartmentObjectives.toJson();
        _ = check db->insert(myDoc, ObjectivesCollection, "");
        return string `$(newObjective.name) added successfully`;
    }

    //DELETE DepartmentObjeective
    remote function DeleteObjectives(string id) returns (string|error) {

        mongodb:Error|int deletedItem = check db->delete(ObjectivesCollection, "", {id: id}, false);

        if deletedItem is mongodb:Error {
            return error("Failed to delete item");
        } else {
            if deletedItem > 0 {
                return string `${id} deleted successfully`;
            } else {
                return string `${id} No deleted items`;
            }

        }
    }
}
