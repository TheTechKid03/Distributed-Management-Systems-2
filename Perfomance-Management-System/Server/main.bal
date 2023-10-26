// Importing necessary dependencies
import ballerina/graphql;
import ballerina/io;
import ballerinax/mongodb;


// This Will be the HOD responsibility
type Users record {
    string Employee_id;
    string First_name;
    string Last_name;
    string Job_title;
    string Position;
    string Role;
    string Department;
    string Supervisor;
    string Employee_score;
};

type Key_Performance_Indicators record {
    string KPI_id;
    string KPI_details;
    string Employee_id;
    string Grade;
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
    databaseName: "Performance_Management_System"
};


// Setting up the database collections
mongodb:Client db = check new (mongoConfig);
configurable string Users_collection = "Users";
configurable string KPIs_collection = "Key Performance Indicators";
configurable string Departments_collection = "Departments";
configurable string databaseName = "Performance_Management_System";


@graphql:ServiceConfig {
    graphiql: {
        enabled: true,
        // Path is optional, if not provided, it will be dafulted to `/graphiql`.
        path: "/PMS"
    }
}


service /Performance on new graphql:Listener(9090) {



 // Ignore this code I didnt have a choice
 resource function get getAllDepartments() returns string|error?{
      stream<Departments,error?> dept = check db->find(Departments_collection);
        Departments[] dept_1= check from var deptInfo in dept select deptInfo ;
        string response = dept_1.toString();
        return response;
    }



    // This section is only for add functions
    // Adding an Users
    remote function Add_a_User(Users newuser) returns error|string {
        io:println("Add a User function triggered");
        map<json> doc = <map<json>>newuser.toJson();
        _ = check db->insert(doc, Users_collection, "");
        return string `${newuser.First_name + " " + newuser.Last_name} added successfully`;
    };

    // Adding a Department
    remote function Add_a_Department(Departments newdepartment) returns error|string {
        io:println("Add a Department function triggered");
        map<json> doc = <map<json>>newdepartment.toJson();
        _ = check db->insert(doc, Departments_collection,databaseName);
        return string `${newdepartment.Department_name} added successfully`;
    };


    // Adding a KPI
    remote function Add_a_KPI(Key_Performance_Indicators newkpi) returns error|string {
        io:println("Add a Key Permance Indicator function triggered");
        map<json> doc = <map<json>>newkpi.toJson();
        _ = check db->insert(doc, KPIs_collection,databaseName);
        return string `${newkpi.KPI_id} added successfully`;
    };

    // This section is only for Delete functions
    // Deleting a Department Objective
   remote function Delete_a_department_objective(Departments deleteobjective) returns error|string {
        map<json> deleteobjectiveDoc = <map<json>>{"$set": {"Department objective": deleteobjective.Department_objective}};
        int updatedCount = check db->update(deleteobjectiveDoc, Departments_collection, databaseName, {Department_objective: deleteobjective.Department_objective}, true, false);
        io:println("Updated Count ", updatedCount);
        if updatedCount > 0 {
            return string `${deleteobjective.Department_name} objective deleted successfully`;
        }
        return "Failed to delete";
    }


    // Deleting an Users KPI
     remote function Delete_an_employee_KPI(string id) returns error|string {
        mongodb:Error|int deleteKPI = db->delete(KPIs_collection, databaseName, {id: id}, false);
        if deleteKPI is mongodb:Error {
            return error("Failed to delete KPI");
        } else {
            if deleteKPI > 0 {
                return string `${id} deleted successfully`;
            } else {
                return string `KPI not found`;
            }
        }

    }



    // This section is only for Update functions
    // Updating a Department objective
    remote function Update_a_Department_objective(Departments newobjective) returns error|string {
        io:println("Update a Department objective function triggered");
        map<json> doc = <map<json>>newobjective.toJson();
        _ = check db->update(doc, Departments_collection, databaseName);
        return string `${newobjective.Department_name} updated successfully`;
    };


    // Updating an Users KPI
    remote function Update_an_Employees_KPI(Key_Performance_Indicators updatekpi) returns error|string {
        io:println("Update an Users KPI function triggered");
        map<json> doc = <map<json>>updatekpi.toJson();
        _ = check db->update(doc, KPIs_collection, databaseName);
        return string `${updatekpi.KPI_id} updated successfully`;
    };

}
