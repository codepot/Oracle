Set echo on;
spool d:hw5spool.sql;
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