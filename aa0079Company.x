/*NAME:		AADIL AHMED ADAM
  DATE:		10/25/2016 
  CS687 DATABASE SYSTEMS PROJECT 1
  
  SOURCE CODE FILE NAME: aa0079Company.x   */
/*************************************************************************************************************/
  
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

EXEC SQL INCLUDE sqlca;

EXEC SQL WHENEVER SQLERROR sqlprint;

int main(int argc, char* argv[]) 
{
	EXEC SQL BEGIN DECLARE SECTION;
    char     EmpSsn[10];
	char     EmpSsn_compare[10];
    int      Pnumber ;
    double   Hours ; 
	char     firstName[20];
	char     Midinitial[20];
	char     lastName[20];
	char     deptname[20];
	char     mgrfname[20];
	char     mgrlname[20];
	float    salary;
	int      dependent_number;
	int      employee_number;
	float    Hours_sum;
	char     Projname[20];
	double   proj_hours;
	int      proj_number;
	int      check;
 
EXEC SQL END DECLARE SECTION;

    EXEC SQL CONNECT TO unix:postgresql://localhost /cs687 USER aa0079 USING "f16687"; 

    //printf("CONNECTED\n");
	
	strcpy(EmpSsn,argv[1]);
	Pnumber = atoi(argv[2]);
	Hours =   atof(argv[3]);
	
	printf("\n User input of ssn project_number and hours\n");
	printf("\n %s %d %lf \n",EmpSsn,Pnumber,Hours);
	printf("\n Fetching the Employee Details\n");
	
	// code to display the Employee personal information
    
	EXEC SQL DECLARE Employee_info CURSOR FOR 
	
		SELECT E.Lname,E.Fname,D.Dname,E.Salary,COUNT(*)
		FROM adambryegowda.EMPLOYEE AS E,adambryegowda.DEPENDENT AS P,adambryegowda.DEPARTMENT AS D 
		WHERE E.Ssn = P.Essn AND E.Dno = D.Dnumber AND  E.Ssn =:EmpSsn 
		GROUP BY E.Ssn,D.Dname;

	EXEC SQL OPEN Employee_info;
	
	EXEC SQL WHENEVER NOT FOUND DO BREAK;
	printf("\n LastName,FirstName,deptname,salary,number_of_dependents\n");
	while (SQLCODE==0)
	{
		EXEC SQL FETCH IN Employee_info INTO :lastName, :firstName,:deptname, :salary, :dependent_number;
		
		printf("%s %s %s %f %d\n",lastName,firstName,deptname,salary,dependent_number);
	}
    
	EXEC SQL WHENEVER NOT FOUND DO BREAK;
	
    EXEC SQL CLOSE Employee_info;
	
	// code to display the project information and the employees working in that project
   
   EXEC SQL DECLARE Project_info CURSOR FOR 
	
	    SELECT P.Pnumber,P.Pname,E.Lname,E.Fname,X.Hours,COUNT(*),Sum(W.Hours)
		FROM adambryegowda.EMPLOYEE AS E, adambryegowda.WORKS_ON AS W, adambryegowda.DEPARTMENT AS D, adambryegowda.PROJECT AS P, adambryegowda.WORKS_ON AS X
		WHERE W.Pno = P.Pnumber AND P.Dnum = D.Dnumber AND E.Ssn = D.Mgr_ssn AND  X.Essn =:EmpSsn AND X.Pno = W.Pno AND  W.Pno IN ( 
			SELECT B.Pno
			FROM adambryegowda.EMPLOYEE AS A, adambryegowda.WORKS_ON AS B	
		    WHERE A.Ssn = B.Essn AND A.Ssn =:EmpSsn ) 
		GROUP BY  P.Pnumber,P.Pname,E.Lname,E.Fname,X.Hours;
		
	EXEC SQL OPEN Project_info ;
	
	EXEC SQL WHENEVER NOT FOUND DO BREAK;
	printf("\n Fetching the project information and Employee information who work in that project\n");
	printf("Pnumber,Pname,lastName,firstName,Hours,employee_number,Hours_sum\n");
	
	while (SQLCODE==0)
	{
		EXEC SQL FETCH IN Project_info INTO :proj_number,:Projname,:mgrlname,:mgrfname,:proj_hours,:employee_number, :Hours_sum;		
		printf("%d %s %s %s %f %d %f\n",proj_number,Projname,mgrlname,mgrfname,proj_hours,employee_number,Hours_sum);
	}
    
	
	EXEC SQL WHENEVER NOT FOUND DO BREAK;
	
	EXEC SQL CLOSE Project_info;
	
   
   // code to display the Employee project information
	
	EXEC SQL DECLARE Employee_project_info CURSOR FOR 
	
		SELECT DISTINCT W.Essn, W.Pno,W.Hours,E.Fname,E.Minit,E.Lname,P.Pname
		FROM adambryegowda.EMPLOYEE AS E,adambryegowda.WORKS_ON AS W,adambryegowda.PROJECT AS P
		WHERE E.Ssn = W.Essn  AND  W.Pno = P.Pnumber AND E.Ssn =:EmpSsn;
		

	EXEC SQL OPEN Employee_project_info;
	
	EXEC SQL WHENEVER NOT FOUND DO BREAK;
	printf("\n Fetching the Employee project information\n");
	while (SQLCODE==0)
	{
		EXEC SQL FETCH IN Employee_project_info INTO :EmpSsn_compare,:proj_number,:proj_hours,:firstName,:Midinitial,:lastName,:Projname;
		printf("%s %d %lf %s %s %s %s\n",EmpSsn_compare, proj_number,proj_hours,firstName,Midinitial,lastName,Projname);
			 
	}

	
	EXEC SQL CLOSE Employee_project_info;
	
	//code to print the employee and project info after insert update delete operations
	
	EXEC SQL DECLARE Employee_project_print CURSOR FOR
	
		SELECT DISTINCT W.Essn, W.Pno, W.Hours, E.Fname, E.Minit, E.Lname, P.Pname
		FROM adambryegowda.EMPLOYEE AS E, adambryegowda.WORKS_ON AS W, adambryegowda.PROJECT AS P
		WHERE E.Ssn=W.Essn AND W.Pno=P.Pnumber AND W.Essn=:EmpSsn AND W.Pno=:Pnumber;
		
	EXEC SQL OPEN Employee_project_print;
	
	EXEC SQL WHENEVER NOT FOUND DO BREAK;
	
	while ( SQLCODE==0)
	{
		EXEC SQL FETCH IN Employee_project_print INTO :EmpSsn_compare,:proj_number, :proj_hours,:firstName, :Midinitial, :lastName, :Projname;
		
	}
	
	EXEC SQL CLOSE Employee_project_print;
	
	
	
	// code to make insert update delect uperations
	EXEC SQL DECLARE Employee_update_insert_delete CURSOR FOR 
	
		  SELECT count(*) 
		  FROM adambryegowda.EMPLOYEE AS E, adambryegowda.WORKS_ON AS W, adambryegowda.PROJECT AS P
		  WHERE W.Pno =:Pnumber AND W.Essn =:EmpSsn ;
		

	EXEC SQL OPEN Employee_update_insert_delete;
	
	EXEC SQL WHENEVER NOT FOUND DO BREAK;
	
	while (SQLCODE==0)
	{
		EXEC SQL FETCH IN Employee_update_insert_delete INTO :check;
		//printf("%d\n", check);
		if (check == 0)
	{
			
			EXEC SQL INSERT INTO adambryegowda.WORKS_ON (Essn, Pno, Hours)
			VALUES (:EmpSsn,:Pnumber,:Hours);
			printf("INSERTED the new tuple\n");
			EXEC SQL SELECT P.Pname INTO :Projname
			FROM adambryegowda.PROJECT AS P
			WHERE P.Pnumber=:Pnumber;
			printf("Employee '%s %s %s' started  to work on %lf hours on project '%s'.\n",firstName,Midinitial,lastName,Hours,Projname);
	}
	
    else 
	{
		  if (Hours == 0)
		   {
			 
			  EXEC SQL DELETE FROM adambryegowda.WORKS_ON 
              WHERE Pno =:Pnumber AND Essn=:EmpSsn;
			  printf("DELETED THE TUPLE\n");
			  printf("Employee '%s %s %s' who was working on %lf hours on project  '%s' stopped working on this project.\n", firstName,Midinitial,lastName,proj_hours, Projname);
		   }
			
		    else 
			{
				 
			     EXEC SQL UPDATE adambryegowda.WORKS_ON 
				 SET Hours =:Hours
			     WHERE Pno =:Pnumber AND Essn=:EmpSsn;
		         printf("UPDATED THE HOUR\n");
				 printf("The number of hours for the employee '%s %s %s' on project '%s' is updated from %lf to %lf\n", firstName,Midinitial,lastName,Projname,proj_hours, Hours);
		    }
	}
			 
	}

	EXEC SQL CLOSE Employee_update_insert_delete;
	
    EXEC SQL COMMIT;

	EXEC SQL DISCONNECT; 

	return 0;

}