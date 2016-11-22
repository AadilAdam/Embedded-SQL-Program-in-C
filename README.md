# Embedded-SQL-Program-in-C
# Using PostgreSQL interactive terminal (not the web user interface), implement the company database schema given in Figure 5.5 of the database textbook. You first need to create corresponding tables and then insert the tuples in Figure 5.6. Domain, key, entity, and referential integrity constraints should be preserved.
 
# Using Empedded SQL in C (ecpg), write a program to implement the following:
    a. Your program should input the SSN of employee, project number, hours for the project, and salary for the employee.
    b. Firstly, list the employee’s name, employee’s department name, salary, and the number of dependents.
    c.Then for each project the employee is working, provide a list of <the project number, the project name, the name of the department manager controlling the project, the number of hours the employee is working on the project, the number of employees working on the project, the total number of hours for the project (by all employees)>.
    d. After providing the current status related with the employee, update the number of hours worked by the employee for the project as follows. 
    e. (Update/Insert/Delete) If the employee is already working on that project, the number of hours will be updated; otherwise a new tuple will be inserted. The program should input the project number, each employee’s SSN and the number of hours from the command line. If the number of hours is 0, the tuple is deleted.
    f. (Update) If the hours are updated, your program should print an update message (e.g., “The number of hours for employee ‘John B Smith’ on project ‘ProductX’ is updated from 32.5 to 30.”).
    g.(Insert) Otherwise an insert message should be printed (e.g., “Employee ‘John B Smith’ started to work on 5 hours on project ‘ProductZ’.”).
    h.(Delete) Note that if the number of hours is set to 0, it means the corresponding tuple should be deleted if it already exists (e.g.,  “Employee ‘John B Smith’ who was working on 5 hours on project ‘ProductZ’ stopped working on this project.”). The parameters will be read from the command line. The message must include the employee name, project name, number of hours, and previous number of hours if applicable.
    i. After this you should again provide the information about the employee and projects the employee is working after this insert/update/delete as done previously.
    j. Your executable file name is YourLoginCompany.
 
# The following is a sample call for a program.
     YourLoginCompany –ssn 123456789 -pno 1 -hours 30
