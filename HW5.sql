Set echo on;
spool d:hw5spool.sql;
/* Exericise 3.6 page 58 */
Create or replace procedure AddMe (
  p_snum Students.snum%type, p_callnum SchClasses.callnum%type) as
    v_capacity number;
	v_registered number;
  begin
	-- get the course capacity
	select capacity into v_capacity from SchClasses where callNum=p_callnum;
	dbms_output.put('Capacity:' || v_capacity);	
	-- count actual add
	Select count(Snum) into v_registered from enrollments where callnum=p_callnum;
    dbms_output.put_line(', Registered: ' || v_registered);	
	-- make deciscion
	If v_registered < v_capacity Then
		Insert into enrollments values (p_snum, p_callnum, null);
		commit;
		dbms_output.put_line('===> Class was added successfully');
	Else
		dbms_output.put_line('===> Sorry! the class is FULL');
	End If;	
  end;
/
show err;
Pause;
Exec AddMe('103', 10110);
Exec AddMe('104', 10130);
/* Exericise 3.10 page 58 */
Create or replace procedure DropMe (
  p_snum Students.snum%type, p_callnum SchClasses.callnum%type) as
    v_count number;
  begin
	-- count Student
	select count(snum) into v_count from enrollments where callNum=p_callnum AND snum=p_snum;	
	-- check if that student has ever enrolled in that class
	If v_count > 0 Then
		UPDATE enrollments SET Grade = 'W' where snum=p_snum AND callnum=p_callnum;
		commit;
		dbms_output.put_line('===> Done! Student #'|| p_snum || ' has just dropped ' || p_callnum || ' with a W.');
	Else
		dbms_output.put_line('===> Alert! Student #'|| p_snum || ' has not ever registered ' || p_callnum);
	End If;	
  end;
/
show err;
Pause;
Exec DropMe('102', 10130);
Exec DropMe('102', 10125);
Spool off;