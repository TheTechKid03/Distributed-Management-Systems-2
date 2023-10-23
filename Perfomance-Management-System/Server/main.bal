import ballerina/graphql;
import ballerina/io;
import ballerinax/mongodb;

// This Will be the HOD responsibility
type Employee record {
    int Employee_id;
    string First_name;
    string Last_name;
    string Job_title;
    string Position;
    string Role;
    string Department;
    string Supervisor;
    int Employee_score;
};

type Key_Performance_Indicators record {
    string KPI_id;
    string KPI;
    int Employee_id;
    string First_name;
    string Last_name;
    float Grade;
    string Approved_or_Denied;
};

type Departments record {
    string Department_name;
    string Department_objective;
};

// Connecting the Mongo Database to our server
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
    databaseName: "Performance Management System"
};

mongodb:Client db = check new (mongoConfig);
configurable string Employees_collection = "Employees";
configurable string KPIs_collection = "Key Performance Indicators";
configurable string Departments_collection = "Departments";
configurable string databaseName = "PerformanceManagement";

@graphql:ServiceConfig {
    graphiql: {
        enabled: true,
        // Path is optional, if not provided, it will be dafulted to `/graphiql`.
        path: "/Performance"
    }
}

service /Performance_Management on new graphql:Listener(2120) {

    // This section is only for add functions
    // Adding an Employee
    remote function Add_an_Employee(Employee newemployee) returns error|string {
        io:println("Add an Employee function triggered");
        map<json> doc = <map<json>>newemployee.toJson();
        _ = check db->insert(doc, Employees_collection, "");
        return string `${newemployee.First_name + " " + newemployee.Last_name} added successfully`;
    };

    // Adding a Department
    remote function Add_a_Department(Departments newdepartment) returns error|string {
        io:println("Add a Department function triggered");
        map<json> doc = <map<json>>newdepartment.toJson();
        _ = check db->insert(doc, Departments_collection, "");
        return string `${newdepartment.Department_name} added successfully`;
    };

    // Adding a Department
    remote function Add_a_KPI(Key_Performance_Indicators newkpi) returns error|string {
        io:println("Add a Key Permance Indicator function triggered");
        map<json> doc = <map<json>>newkpi.toJson();
        _ = check db->insert(doc, KPIs_collection, "");
        return string `${newkpi.KPI} added successfully`;
    };

    // This section is only for Delete functions
    // Deleting a Department Objective
   remote function Delete_a_department_objective(Departments deleteobjective) returns error|string {
        map<json> newobjectiveDoc = <map<json>>{"$set": {"Department objective": deleteobjective.Department_objective}};
        int updatedCount = check db->update(newobjectiveDoc, Departments_collection, databaseName, {Department_objective: deleteobjective.Department_objective}, true, false);
        io:println("Updated Count ", updatedCount);
        if updatedCount > 0 {
            return string `${deleteobjective.Department_objective} objective deleted successfully`;
        }
        return "Failed to delete";
    }

}
