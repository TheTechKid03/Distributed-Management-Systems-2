import ballerina/io;
import ballerina/graphql;



public function Login_menu() returns error? {
    graphql:Client Client = check new ("localhost:2120/Performance_Management_System");
    io:println("---------------------------------------------------------------------");
    io:println("|                                                                   |");
    io:println("|                            LOGIN MENU                             |");
    io:println("|                                                                   |");
    io:println("---------------------------------------------------------------------");
    io:println("|                                                                   |");
    io:println("|1.  Add a new department/objective                                 |");
    io:println("|2.  Delete a department/objective                                  |");
    io:println("|3.  Update an existing departments objective                       |");
    io:println("|4.  View employees total scores                                    |");
    io:println("|5.  Assign an employee a supervisor                                |");
    io:println("|6.  Back to main menu                                              |");
    io:println("---------------------------------------------------------------------");
    string option = io:readln("Choose an option: ");

}




public function HOD_menu() returns error? {
    graphql:Client Client = check new ("localhost:2120/Performance_Management_System");
    io:println("---------------------------------------------------------------------");
    io:println("|                                                                   |");
    io:println("|                       HEAD OF DEPARTMENT MENU                     |");
    io:println("|                                                                   |");
    io:println("---------------------------------------------------------------------");
    io:println("|1.  Add a new department/objective                                 |");
    io:println("|2.  Delete a department/objective                                  |");
    io:println("|3.  Update an existing departments objective                       |");
    io:println("|4.  View employees total scores                                    |");
    io:println("|5.  Assign an employee a supervisor                                |");
    io:println("|6.  Back to main menu                                              |");
    io:println("---------------------------------------------------------------------");
    string option = io:readln("Choose an option: ");

}