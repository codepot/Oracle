Set echo on;
spool d:hw6spool.sql;
/* Homework #6. Function and Procedures page 68 */
Create or replace function func_validate_snum (
  p_snum Students.snum%type) return varchar2 as 
  v_count number;
  begin
	-- count snum
	select count(snum) into v_count from students where snum=p_snum;	
	-- check if that student number exists in Students table
	If v_count > 0 Then
		return null;
	Else
		return 'student #' || p_snum || ' is invalid';
	End If;	
  end;
/

Create or replace function func_validate_callnum (
  p_callnum SchClasses.callnum%type) return varchar2 as
  v_count number;
  begin
	-- count callnum
	select count(callnum) into v_count from schclasses where callNum=p_callnum;	
	-- check if that class exists in the schclasses table
	If v_count > 0 Then
		return null;
	Else
		return 'call #' || p_callnum || ' is invalid';
	End If;	
  end;
/
show err;
Pause;

Create or replace procedure Check_Capacity (
  p_snum IN Students.snum%type, p_callnum IN SchClasses.callnum%type, 
  p_error_msg OUT Varchar2) as
     v_capacity number;
	 v_registered number;
  begin
	-- get the course capacity
	select capacity into v_capacity from SchClasses where callNum=p_callnum;	
	Select count(Snum) into v_registered from enrollments where callnum=p_callnum;    
	If v_registered < v_capacity Then
		p_error_msg := null;
	Else
		p_error_msg := 'the class was full';
	End If;	
  end;
/

Create or replace procedure Check_Unit_Limit (
  p_snum IN Students.snum%type, p_callnum IN SchClasses.callnum%type, 
  p_error_msg OUT Varchar2) as
     v_unit number;
	 v_Unit_registered number;
  begin
	select CRHR into v_unit from courses c, schclasses s where callnum=p_callnum AND s.dept=c.dept AND s.cnum=c.cnum;
	select sum(CRHR) into v_Unit_registered from courses c, schclasses s, enrollments e where e.snum=p_snum 
	AND e.callnum = s.callnum AND s.dept = c.dept AND s.cnum = c.cnum;    
	-- make deciscion
	If v_unit + v_Unit_registered <= 13 Then
		p_error_msg := null;
	Else
		p_error_msg := '15 units exceeded';
	End If;	
  end;
/

-- MAIN PROCEDURE FOR HOMEWORK #6
Create or replace procedure AddMe (
  p_snum Students.snum%type, p_callnum SchClasses.callnum%type) as
  v_valid_snum_msg varchar2(50);
  v_valid_callnum_msg varchar2(50);
  v_valid_capacity_msg varchar2(50);
  v_valid_limit_msg varchar2(50);
  v_error_msg varchar2(100);    
  begin
	v_valid_snum_msg := func_validate_snum(p_snum);
	v_valid_callnum_msg := func_validate_callnum(p_callnum);
	v_error_msg := v_valid_snum_msg || v_valid_callnum_msg;
	IF v_error_msg is null THEN
		 Check_Capacity(p_snum, p_callnum, v_valid_capacity_msg);
		 Check_Unit_Limit(p_snum, p_callnum, v_valid_limit_msg);
		 v_error_msg := v_valid_capacity_msg || v_valid_limit_msg;
		 If v_error_msg is null Then
				-- all conditions are satisfied
				Insert into enrollments values (p_snum, p_callnum, null);
				-- commit;
		 Else			
				if v_valid_capacity_msg is Not null  and v_valid_limit_msg is not null then
					v_error_msg := v_valid_capacity_msg || ', and ' ||v_valid_limit_msg;				
				end if;				
		 End If;		 
	ELSE
		 If v_valid_snum_msg is Not Null AND v_valid_callnum_msg is not Null Then
			v_error_msg := v_valid_snum_msg || ', and ' || v_valid_callnum_msg;		
		 End If;
	END IF;
	-- PRINT RESULT
	IF v_error_msg is null THEN
		 dbms_output.put_line('Enrolled Successfully');
	ELSE
		 dbms_output.put_line('Enrollment Errors: ' || v_error_msg);
	END IF;	
  end;
/
show err;
Pause;
Exec AddMe(103, 10110);
Exec AddMe(114, 10112);
Exec AddMe(103, 10177);
Exec AddMe(114, 10110);
Exec AddMe(104, 10125);
Exec AddMe(105, 10160);
Exec AddMe(101, 10140);
Exec AddMe(101, 10160);
Spool off;