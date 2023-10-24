import ballerina/graphql;
import ballerina/io;

type deptResponse record{
	record {Department department;} data;
};

public type Department record{
	string d_name;
	string d_head;
};

public function main() returns error?{
	graphql:Client client_side =check new ("localhost:9090/graphql");
	string document = "{department {d_name, d_head}}";
	
	deptResponse response = check client_side->execute(document);
	io:println(response.data.department);
}
