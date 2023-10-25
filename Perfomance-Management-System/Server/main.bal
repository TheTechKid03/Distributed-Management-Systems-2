import ballerina/graphql;
import ballerina/io;
import ballerinax/mongodb;

//Records for Authentication
type User record {
    string username;
    string password;
};

type UserDetails record {
    string username;
    string? password;
    boolean isAdmin;
};

type UpdatedUserDetails record {
    string username;
    string password;
};

type LoggedUserDetails record {|
    string username;
    boolean isAdmin;
|};

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
    databaseName: "FCI-ManagementSystem"

};
mongodb:Client db = check new (mongoConfig);

//collections below
//configurable string ObjectivesCollection = "DepartmentObjectives";
configurable string userCollection = "Users";
configurable string databaseName = "FCI-ManagementSystem";

@graphql:ServiceConfig {
    graphiql: {
        enabled: true,
        // Path is optional, if not provided, it will be dafulted to `/graphiql`.
        path: "/graphql"
    }
}

//Creating the service
service /FCIManagemetSystem on new graphql:Listener(2120) {

    //for [query] you use (resourse function)
    //for Mutations, you use (remote functions)


    //Get username and password from client, and check mondo db, if details are valid or not

    //Query operations below:
    resource function get login(User user) returns LoggedUserDetails|error {
        stream<UserDetails, error?> usersDeatils = check db->find(userCollection, databaseName, {username: user.username, password: user.password}, {});

        UserDetails[] users = check from var userInfo in usersDeatils
            select userInfo;
        io:println("Users ", users);
        // If the user is found return a user or return a string user not found
        if users.length() > 0 {
            return {username: users[0].username, isAdmin: users[0].isAdmin};
        }
        return {
            username: "",
            isAdmin: false
        };
    }

//Mutation operation below:


//Regitering new username and Password
remote function register(User newuser) returns error|string {

        map<json> doc = <map<json>>{isAdmin: false, username: newuser.username, password: newuser.password};
        _ = check db->insert(doc, userCollection, "");
        return string `${newuser.username} added successfully`;
    }

    // Function change the user password by updating the user using mongoDB update function $set
    // Mongo db update function comes with different functions that you can use to modify your data
    // + $push and $pull for arrays inside your document
    // + $set for replace a value for example password.
    //Funnction for Changing password, NOT asked in the Assignment but just added it anyways :)
    remote function changePassword(UpdatedUserDetails updatedUser) returns error|string {

        map<json> newPasswordDoc = <map<json>>{"$set": {"password": updatedUser.password}};

        int updatedCount = check db->update(newPasswordDoc, userCollection, databaseName, {username: updatedUser.username}, true, false);
        io:println("Updated Count ", updatedCount);

        if updatedCount > 0 {
            return string `${updatedUser.username} password changed successfully`;
        }
        return "Failed to Change password";
    }
}

