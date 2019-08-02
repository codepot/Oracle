Set echo on;
spool d:hw7spool.sql;
Create or Replace Package ENROLL is
Function func_validate_snum (
  p_snum Students.snum%type) return varchar2;
Function func_validate_callnum (
  p_callnum SchClasses.callnum%type) return varchar2;
Procedure AddMe (
  p_snum Students.snum%type, p_callnum SchClasses.callnum%type);
End ENROLL;
/
show error;
pause;
Create or replace Package Body ENROLL is
Function func_validate_snum (
  p_snum Students.snum%type) return varchar2 is
  v_count number;
  begin
	select count(snum) into v_count from students where snum=p_snum;	
	If v_count > 0 Then
		return null;
	Else
		return 'student #' || p_snum || ' is invalid';
	End If;	
  end;
Function func_validate_callnum (
  p_callnum SchClasses.callnum%type) return varchar2 is
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
Procedure Check_Capacity (
  p_snum IN Students.snum%type, p_callnum IN SchClasses.callnum%type, 
  p_error_msg OUT Varchar2) is
     v_capacity number;
	 v_registered number;
  begin
	select capacity into v_capacity from SchClasses where callNum=p_callnum;	
	Select count(Snum) into v_registered from enrollments where callnum=p_callnum;    
	If v_registered < v_capacity Then
		p_error_msg := null;
	Else
		p_error_msg := 'the class was full';
	End If;	
  end;
Procedure Check_Unit_Limit (
  p_snum IN Students.snum%type, p_callnum IN SchClasses.callnum%type, 
  p_error_msg OUT Varchar2) is
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
Procedure AddMe (
  p_snum Students.snum%type, p_callnum SchClasses.callnum%type) is
  v_valid_snum_msg varchar2(50);
  v_valid_callnum_msg varchar2(50);
  v_valid_capacity_msg varchar2(50);
  v_valid_limit_msg varchar2(50);
  v_error_msg varchar2(100);    
  begin
	v_valid_snum_msg := func_validate_snum(p_snum);
	v_valid_callnum_msg := func_validate_callnum(p_callnum);	
	IF v_valid_snum_msg is null AND v_valid_callnum_msg is null then
		Check_Capacity(p_snum, p_callnum, v_valid_capacity_msg);
		Check_Unit_Limit(p_snum, p_callnum, v_valid_limit_msg); 
		IF v_valid_capacity_msg is null Then
			if v_valid_limit_msg is null then
				Insert into enrollments values (p_snum, p_callnum, null);
				v_error_msg := null;
				-- commit;
			else 
				v_error_msg := v_valid_limit_msg;
			end if;
		Else
			if v_valid_limit_msg is null then				
				v_error_msg := v_valid_capacity_msg;
				-- commit;
			else 
				v_error_msg :=  v_valid_capacity_msg || ', and ' || v_valid_limit_msg;
			end if;		
		End If;
	ELSE
		If v_valid_snum_msg is not null Then
			if v_valid_callnum_msg is not null then
				v_error_msg := 'Both ' || p_snum || ' and ' || p_callnum || ' are invalid';
			else
				v_error_msg := v_valid_snum_msg;
			end if;
		Else
			v_error_msg := v_valid_callnum_msg;
		End If;		
	END IF;	
	-- FINALLY, PRINT MESSAGE
	IF v_error_msg is null THEN
		 dbms_output.put_line('Enrolled Successfully');
	ELSE
		 dbms_output.put_line('Enrollment Errors: ' || v_error_msg);
	END IF;	
  end;
End ENROLL;
/
show error;
pause;
Exec ENROLL.AddMe(103, 10110);
Exec ENROLL.AddMe(114, 10112);
Exec ENROLL.AddMe(103, 10177);
Exec ENROLL.AddMe(114, 10110);
Exec ENROLL.AddMe(104, 10125);
Exec ENROLL.AddMe(105, 10160);
Exec ENROLL.AddMe(101, 10140);
Exec ENROLL.AddMe(101, 10160);
Spool off;