import ballerina/io;
import ballerina/graphql;


// This Will be the HOD responsibility
type Users record {
    string Employee_id?;
    string First_name?;
    string Last_name?;
    string Job_title?;
    string Position?;
    string Role?;
    string Department?;
    string Supervisor?;
    string Employee_score?;
};

type Key_Performance_Indicators record {
    string KPI_id?;
    string KPI_details?;
    string Employee_id?;
    string Grade?;
    string Approved_or_Denied?;
};

type Departments record {
    string Department_name?;
    string Department_objective?;
};


type AddUserResp record {|
    record {|anydata dt;|} data;
|};

type AddDepResp record {|
    record {|anydata dt;|} data;
|};

type AddDKPIResp record {|
    record {|anydata dt;|} data;
|};

public function main() returns error? {
    graphql:Client Client = check new ("localhost:9090/Performance");
    io:println("---------------------------------------------------------------------");
    io:println("|                                                                   |");
    io:println("|           ULTIMATE PERFORMANCE MANAGEMENT SYSTEM V7.0.2           |");
    io:println("|         -------------------------------------------------         |");
    io:println("|               By: - Michael Amutenya (TheTechKid)                 |");
    io:println("|                       - Karel Ndumba                              |");
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
            Users User = {Department: " ", Supervisor: " ", Employee_score: " "};
            User.Employee_id = io:readln("Enter Users ID: ");
            User.First_name = io:readln("Enter First Name: ");
            User.Last_name = io:readln("Enter Last Name: ");
            User.Job_title = io:readln("Enter Job Title: ");
            User.Position = io:readln("Enter Position: ");
            User.Role = io:readln("Enter Role: ");
           
            // Define the GraphQL mutation document, variables, and operationName
            string doc = string `
            mutation Add_a_User($Employee_id:String!,$First_name:String!,$Last_name:String!,$Job_title:String!,
            $Position:String!,$Role:String!,$Department:String!,$Supervisor:String!,$Employee_score:String!){
            Add_a_User(newuser:{Employee_id:$Employee_id,First_name:$First_name,Last_name:$Last_name
            ,Job_title:$Job_title,Position:$Position,Role:$Role,Department:$Department
            ,Supervisor:$Supervisor,Employee_score:$Employee_score})
             }`;

             AddUserResp adduserResponse = check Client -> execute(doc, {"Employee_id": User.Employee_id,
             "First_name":  User.First_name, "Last_name": User.Last_name, "Job_title":  User.Job_title, "Position": User.Position,
             "Role": User.Role, "Department": "" , "Supervisor": "", "Employee_score": ""});

             io:println("Response ", adduserResponse);
        }

        "2" => {
            Departments Department = {};
            Department.Department_name = io:readln("Enter The Department Name: ");
            Department.Department_objective = io:readln("Enter The Departments Objective: ");

            // Define the GraphQL mutation document, variables, and operationName
           
            string doc = string `
            mutation Add_a_Department($Department_name:String!,$Department_objective:String!){
            Add_a_Department(newdepartment:{Department_name:$Department_name,Department_objective:$Department_objective})
             }`;

             AddDepResp addDepResponse = check Client->execute(doc, {"Department_name": Department.Department_name,"Department_objective": Department.Department_objective});

                  io:println("Response ", addDepResponse);
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
          Key_Performance_Indicators key = {Grade: "", Approved_or_Denied: ""};
            key.KPI_id = io:readln("Enter KPI's ID: ");
            key.KPI_details = io:readln("Enter KPI's Details: ");
            key.Employee_id = io:readln("Enter Employee ID of User Who Created The KPI: ");
            
            // Define the GraphQL mutation document, variables, and operationName
            string doc = string `
            mutation Add_a_KPI($KPI_id:String!,$KPI_details:String!,$Employee_id:String!,$Grade:String!, $Approved_or_Denied:String!){
            Add_a_KPI(newkpi:{KPI_id:$KPI_id,KPI_details:$KPI_details,Employee_id:$Employee_id,
            Grade:$Grade,Approved_or_Denied:$Approved_or_Denied})
             }`;

            AddDKPIResp addkpiResponse = check Client -> execute(doc, {"KPI_id": key.KPI_id,
             "KPI_details":  key.KPI_details, "Employee_id":  key.Employee_id, "Grade": "" , "Approved_or_Denied": ""});

             io:println("Response ", addkpiResponse);

         
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