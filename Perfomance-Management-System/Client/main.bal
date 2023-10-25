import ballerina/io;
import ballerina/graphql;


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
    string KPI;
    string Employee_id;
    string First_name;
    string Last_name;
    string Grade;
    string Approved_or_Denied;
};

type Departments record {
    string Department_name?;
    string Department_objective?;
};






public function main() returns error? {
    graphql:Client Client = check new ("localhost:9090/Performance");
    io:println("---------------------------------------------------------------------");
    io:println("|                                                                   |");
    io:println("|           ULTIMATE PERFORMANCE MANAGEMENT SYSTEM V7.0.2           |");
    io:println("|         -------------------------------------------------         |");
    io:println("|               By: - Michael Amutenya (TheTechKid)                 |");
    io:println("|                       - Karel Pieters                             |");
    io:println("|                           - Barkias Shapaka                       |");
    io:println("|                              - Festus Alpheus (FessyNam)          |");
    io:println("---------------------------------------------------------------------");
    io:println("|1.  Login as a Head Of Deparment                                   |");
    io:println("|2.  Login as a Supervisor                                          |");
    io:println("|3.  Login as an Employee                                           |");                               
    io:println("---------------------------------------------------------------------");
    string option = io:readln("Choose an option: ");

 match option {
        "1" => {
           check HOD_menu();
//            var loginResponse = graphqlClient->execute(string`
//      query{
//    get login(user: {username: "karel", password: "pass123"})
//  }
//   `,{},"",{}, []);

//  io:println (loginResponse) ;
        }


        "2" => {
           check Supervisor_menu();
           //            var loginResponse = graphqlClient->execute(string`
//      query{
//    get login(user: {username: "karel", password: "pass123"})
//  }
//   `,{},"",{}, []);

//  io:println (loginResponse) ;
        }


        "3" => {
           check Employee_menu();
        }
        //            var loginResponse = graphqlClient->execute(string`
//      query{
//    get login(user: {username: "karel", password: "pass123"})
//  }
//   `,{},"",{}, []);

//  io:println (loginResponse) ;


        _ => {
            io:println("Invalid Option");
            check main();
        }
 }
}


public function HOD_menu() returns error? {
    graphql:Client Client = check new ("localhost:9090/Performance");
    io:println("---------------------------------------------------------------------");
    io:println("|                                                                   |");
    io:println("|                       HEAD OF DEPARTMENT MENU                     |");
    io:println("|                                                                   |");
    io:println("---------------------------------------------------------------------");
    io:println("|1.  Add a new User                                                 |");
    io:println("|2.  Add a new department/objective                                 |");
    io:println("|3.  Delete a department/objective                                  |");
    io:println("|4.  Update an existing departments objective                       |");
    io:println("|5.  View employees total scores                                    |");
    io:println("|6.  Assign an employee a supervisor                                |");
    io:println("|7.  Logout of user                                                 |");
    io:println("---------------------------------------------------------------------");
    string option = io:readln("Choose an option: ");

match option {
        "1" => {
          Departments Department = {};
            Department.Department_name = io:readln("Enter The Department Name: ");
            Department.Department_objective = io:readln("Enter The Departments Objective: ");

            string document = string `
                        mutation{
                          Add_a_Department($Department_name: String, $Department_objective: String){
                                Add_a_Department(newdepartment: 
                                {Department_name: $Department_name, Department_objective: $Department_objective})
                            }
                    }
            `;

        var Add_a_department_response = check Client -> execute (document, {Department_name, Department_objective}, "AddDepartment", {}, []);
        io:println(Add_a_department_response);

        } 


        "2" => {
          
        }


        "3" => {
          
        }


        "4" => {
          
        }


        "5" => {
          
        }


        "6" => {
          
        }


        "7" => {
           check main();
        }


        _ => {
            io:println("Invalid Option");
            check HOD_menu();
        }
 }

}


public function Supervisor_menu() returns error? {
    graphql:Client Client = check new ("localhost:9090/Performance");
    io:println("---------------------------------------------------------------------");
    io:println("|                                                                   |");
    io:println("|                           SUPERVISOR MENU                         |");
    io:println("|                                                                   |");
    io:println("---------------------------------------------------------------------");
    io:println("|1.  Approve Employee's KPIs                                        |");
    io:println("|2.  Delete Employee’s KPIs                                         |");
    io:println("|3.  Update Employee's KPIs                                         |");
    io:println("|4.  View Employee Scores [Supervisor filter]                       |");
    io:println("|5.  Grade the employee’s KPIs                                      |");
    io:println("|6.  Logout of user                                                 |");
    io:println("---------------------------------------------------------------------");
    string option = io:readln("Choose an option: ");

match option {
         "1" => {
          
        }


        "2" => {
          
        }


        "3" => {
          
        }


        "4" => {
          
        }


        "5" => {
          
        }


        "6" => {
           check main();
        }


        _ => {
            io:println("Invalid Option");
            check Supervisor_menu();
        }
 }

}




public function Employee_menu() returns error? {
    graphql:Client Client = check new ("localhost:9090/Performance");
    io:println("---------------------------------------------------------------------");
    io:println("|                                                                   |");
    io:println("|                           EMPLOYEE MENU                           |");
    io:println("|                                                                   |");
    io:println("---------------------------------------------------------------------");
    io:println("|1.  Create their KPIs                                              |");
    io:println("|2.  Grade their Supervisor                                         |");
    io:println("|3.  View Their Scores                                              |");
    io:println("|4.  Logout of user                                                 |");
    io:println("---------------------------------------------------------------------");
    string option = io:readln("Choose an option: ");

match option {
        "1" => {
         
        }


        "2" => {
        
        }


        "3" => {
           
        }


        "4" => {
            check main();
        }


        _ => {
            io:println("Invalid Option");
            check Employee_menu();
        }
 }

}