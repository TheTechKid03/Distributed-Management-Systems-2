import ballerina/graphql;
import ballerina/io;

public function main() returns error? {
    graphql:Client graphqlClient = check new ("localhost:2120/graphql");
    
    var addDepartmentResponse = graphqlClient->execute(string `
    mutation{
        addProduct(newproduct:{id:"785362",name:"Soap",price:56,quantity:20})
    }
    `, {}, "", {}, []);

    
    io:println(addDepartmentResponse);
    
}