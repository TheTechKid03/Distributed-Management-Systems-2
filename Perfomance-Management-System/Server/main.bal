import ballerina/graphql;


public type Department record{
	string d_name;
	string d_head;
};


service /graphql on new graphql:Listener(9090){
	resource function get department() returns Department{
		return {d_name: "Shacakes", d_head: "zeze" };
	}
}
