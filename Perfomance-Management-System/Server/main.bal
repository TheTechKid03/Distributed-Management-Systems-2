import ballerina/graphql;
import ballerina/io;
import ballerinax/mongodb;

type Users record {
    int userId;
    string firstName;
    string lastName;
    string jobTitle;
    string position;
    string role;
};

type KPIs record {
    int kpiId;
    int userId;
    string name;
    float value;
};

type Departments record {
    int departmentId;
    string name;
    float objectivesPercentage;
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
    databaseName: "PerformanceManagement"
};

mongodb:Client db = check new (mongoConfig);
configurable string kpiCollection = "KPIs";
configurable string employeeCollection = "Employees";
configurable string databaseName = "PerformanceManagement";

@graphql:ServiceConfig {
    graphiql: {
        enabled: true,
    // Path is optional, if not provided, it will be dafulted to `/graphiql`.
    path: "/shopping"
    }
}
service /PerformanceManagement on new graphql:Listener(2120) {
//mutation starts

remote function addDepartment(string name, float objectivesPercentage) returns Departments|error {
    io:println("addDepartment function invoked");
    var department = {
        departmentId: 0,
        name: name,
        objectivesPercentage: objectivesPercentage
    };
    var result = db->insert(department, databaseName, "Departments");
    if (result is error) {
        return error("Error while inserting the department");
    }
    return department;
}
};

// remote function adduser(Users user) returns Users|error {
//     map<json> employee.toJson();
//     _= check db->insert(employee, databaseName, "Employees");
//     return string `${user.firstName} ${user.lastName}`;
// }
// function addKPI(int userId, string name, float value) returns KPIs|error {
//     io:println("addKPI function invoked");
//     var kpi = {
//         kpiId: 0,
//         userId: userId,
//         name: name,
//         value: value
//     };
//     var result = db->insert(kpi, databaseName, "KPIs");
//     if (result is error) {
//         return error("Error while inserting the KPI");
//     }
//     return kpi;
// };

// function addEmployee(int userId, string firstName, string lastName, string jobTitle, string position, string role) returns Users|error {
//     io:println("addEmployee function invoked");
//     var employee = {
//         userId: userId,
//         firstName: firstName,
//         lastName: lastName,
//         jobTitle: jobTitle,
//         position: position,
//         role: role
//     };
//     var result = db->insert(employee, databaseName, "Employees");
//     if (result is error) {
//         return error("Error while inserting the employee");
//     }
//     return employee;
// };

// function getDepartments() returns Departments[]|error {
//     io:println("getDepartments function invoked");
//     var result = db->find(databaseName, "Departments");
//     if (result is error) {
//         return error("Error while retrieving the departments");
//     }
//     return result;
// };

// function getDepartmentsById(int departmentId) returns Departments|error {
//     io:println("getDepartmentsById function invoked");
//     var result = db->findOne(departmentId, databaseName, "Departments");
//     if (result is error) {
//         return error("Error while retrieving the department");
//     }
//     return result;
// }

// remote function getKPIs(int userId) returns KPIs[]|error {
//     io:println("getKPIs function invoked");
//     var result = db->find(userId, databaseName, "KPIs");
//     if (result is error) {
//         return error("Error while retrieving the KPIs");
//     }
//     return result;
// };
// remote function updateKPI(int kpiId, int userId, string name, float value) returns KPIs|error {
//     io:println("updateKPI function invoked");
//     var kpi = {
//         kpiId: kpiId,
//         userId: userId,
//         name: name,
//         value: value
//     };
//     var result = db->update(kpi, databaseName, "KPIs");
//     if (result is error) {
//         return error("Error while updating the KPI");
//     }
//     return kpi;
// };
// remote function deleteKPI(int kpiId) returns boolean|error {
//     io:println("deleteKPI function invoked");
//     var result = db->deleteOne(kpiId, databaseName, "KPIs");
//     if (result is error) {
//         return error("Error while deleting the KPI");
//     }
//     return result;
// };
// remote function getEmployees() returns Users[]|error {
//     io:println("getEmployees function invoked");
//     var result = db->find(databaseName, "Employees");
//     if (result is error) {
//         return error("Error while retrieving the employees");
//     }
//     return result;
// };
// remote function getEmployeeById(int userId) returns Users|error {
//     io:println("getEmployeeById function invoked");
//     var result = db->findOne(userId, databaseName, "Employees");
//     if (result is error) {
//         return error("Error while retrieving the employee");
//     }
//     return result;
// };
// remote function updateEmployee(int userId, string firstName, string lastName, string jobTitle, string position, string role) returns Users|error {
//     io:println("updateEmployee function invoked");
//     var employee = {
//         userId: userId,
//         firstName: firstName,
//         lastName: lastName,
//         jobTitle: jobTitle,
//         position: position,
//         role: role
//     };
//     var result = db->update(employee, databaseName, "Employees");
//     if (result is error) {
//         return error("Error while updating the employee");
//     }
//     return employee;
// };
// remote function deleteEmployee(int userId) returns boolean|error {
//     io:println("deleteEmployee function invoked");
//     var result = db->deleteOne(userId, databaseName, "Employees");
//     if (result is error) {
//         return error("Error while deleting the employee");
//     }
//     return result;
// };
// remote function addKPIToEmployee(int kpiId, int userId) returns boolean|error {
//     io:println("addKPIToEmployee function invoked");
//     var result = db->update(kpiId, userId, databaseName, "Employees");
//     if (result is error) {
//         return error("Error while adding the KPI to the employee");
//     }
//     return result;
// };
// remote function removeKPIFromEmployee(int kpiId, int userId) returns boolean|error {
//     io:println("removeKPIFromEmployee function invoked");
//     var result = db->update(kpiId, userId, databaseName, "Employees");
//     if (result is error) {
//         return error("Error while removing the KPI from the employee");
//     }
//     return result;
// };
// remote function getEmployeeKPIs(int userId) returns KPIs[]|error {
//     io:println("getEmployeeKPIs function invoked");
//     var result = db->find(userId, databaseName, "Employees");
//     if (result is error) {
//         return error("Error while retrieving the employee KPIs");
//     }
//     return result;
// };
// remote function getDepartmentKPIs(int departmentId) returns KPIs[]|error {
//     io:println("getDepartmentKPIs function invoked");
//     var result = db->find(departmentId, databaseName, "Departments");
//     if (result is error) {
//         return error("Error while retrieving the department KPIs");
//     }
//     return result;
// };
// remote function addDepartment(int departmentId, string name) returns Departments|error {
//     io:println("addDepartment function invoked");
//     var department = {
//         departmentId: departmentId,
//         name: name
//     };
//     var result = db->insert(department, databaseName, "Departments");
//     if (result is error) {
//         return error("Error while inserting the department");
//     }
//     return department;
// };
// remote function updateDepartment(int departmentId, string name) returns Departments|error {
//     io:println("updateDepartment function invoked");
//     var department = {
//         departmentId: departmentId,
//         name: name
//     };
//     var result = db->update(department, databaseName, "Departments");
//     if (result is error) {
//         return error("Error while updating the department");
//     }
//     return department;
// };
// remote function deleteDepartment(int departmentId) returns boolean|error {
//     io:println("deleteDepartment function invoked");
//     var result = db->deleteOne(departmentId, databaseName, "Departments");
//     if (result is error) {
//         return error("Error while deleting the department");
//     }
//     return result;
// };
// remote function addKPI(int kpiId, int userId, string name, float value) returns KPIs|error {
//     io:println("addKPI function invoked");
//     var kpi = {
//         kpiId: kpiId,
//         userId: userId,
//         name: name,
//         value: value
//     };
//     var result = db->insert(kpi, databaseName, "KPIs");
//     if (result is error) {
//         return error("Error while inserting the KPI");
//     }
//     return kpi;
// };
// remote function addEmployee(int userId, string firstName, string lastName, string jobTitle, string position, string role) returns Users|error {
//     io:println("addEmployee function invoked");
//     var employee = {
//         userId: userId,
//         firstName: firstName,
//         lastName: lastName,
//         jobTitle: jobTitle,
//         position: position,
//         role: role
//     };
//     var result = db->insert(employee, databaseName, "Employees");
//     if (result is error) {
//         return error("Error while inserting the employee");
//     }
//     return employee;
// };
// remote function updateKPI(int kpiId, int userId, string name, float value) returns KPIs|error {
//     io:println("updateKPI function invoked");
//     var kpi = {
//         kpiId: kpiId,
//         userId: userId,
//         name: name,
//         value: value
//     };
//     var result = db->update(kpi, databaseName, "KPIs");
//     if (result is error) {
//         return error("Error while updating the KPI");
//     }
//     return kpi;
// };
// remote function deleteKPI(int kpiId) returns boolean|error {
//     io:println("deleteKPI function invoked");
//     var result = db->deleteOne(kpiId, databaseName, "KPIs");
//     if (result is error) {
//         return error("Error while deleting the KPI");
//     }
//     return result;
// };
// remote function getKPIById(int kpiId) returns KPIs|error {
//     io:println("getKPIById function invoked");
//     var result = db->findOne(kpiId, databaseName, "KPIs");
//     if (result is error) {
//         return error("Error while retrieving the KPI");
//     }
//     return result;
// };
// remote function getKPIs() returns KPIs[]|error {
//     io:println("getKPIs function invoked");
//     var result = db->getAll(databaseName, "KPIs");
//     if (result is error) {
//         return error("Error while retrieving the KPIs");
//     }
//     return result;
// };
// remote function getEmployeeById(int userId) returns Users|error {
//     io:println("getEmployeeById function invoked");
//     var result = db->findOne(userId, databaseName, "Employees");
//     if (result is error) {
//         return error("Error while retrieving the employee");
//     }
//     return result;
// };
// remote function getEmployees() returns Users[]|error {
//     io:println("getEmployees function invoked");
//     var result = db->getAll(databaseName, "Employees");
//     if (result is error) {
//         return error("Error while retrieving the employees");
//     }
//     return result;
// };
// remote function getDepartmentById(int departmentId) returns Departments|error {
//     io:println("getDepartmentById function invoked");
//     var result = db->findOne(departmentId, databaseName, "Departments");
//     if (result is error) {
//         return error("Error while retrieving the department");
//     }
//     return result as Departments;
//     return result;
// }
