import ballerina/graphql;
import ballerina/io;

public function main() returns error? {
    //Passing the root path ---> FCIManagemetSystem
    graphql:Client graphqlClient = check new ("localhost:2120/FCIManagemetSystem");

    //Login
    var loginResponse = graphqlClient->execute(string`
    query{
  get login(user: {username: "karel", password: "pass123"})
}
 `,{},"",{}, []);

io:println (loginResponse) ;
}
//Will fix the error after my poer nap :)


