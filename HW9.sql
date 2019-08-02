Set echo on;
spool d:hw9spool.sql;
/* HOMEWORK 9 - PAGE 86*/
Create or Replace Package ENROLL is
	Procedure AddMe (
	  p_snum Students.snum%type, p_callnum SchClasses.callnum%type);
End ENROLL;
/

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
	
	Procedure validate_callnum(
	  p_callnum SchClasses.callnum%type) is
	  v_callnum SchClasses.callnum%type;
	 begin
		-- count callnum
		select callnum into v_callnum from schclasses where callNum=p_callnum;	
		exception
		when NO_DATA_FOUND then
			dbms_output.put_line('- ' || p_callnum || ' is invalid');
	end;
  
	Procedure Check_Capacity (
	  p_snum IN Students.snum%type, p_callnum IN SchClasses.callnum%type, 
	  p_error_msg OUT Varchar2) is
		 v_capacity number;
		 v_registered number;
	  begin
		select capacity into v_capacity from SchClasses where callNum=p_callnum;	
		Select nvl(count(Snum),0) into v_registered from enrollments where callnum=p_callnum;  
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
		select nvl(sum(CRHR),0) into v_Unit_registered from courses c, schclasses s, enrollments e where e.snum=p_snum 
		AND e.callnum = s.callnum AND s.dept = c.dept AND s.cnum = c.cnum;    
		-- make deciscion
		If v_unit + v_Unit_registered <= 15 Then
		p_error_msg := null;
		Else
		p_error_msg := '15 units exceeded';
		End If;	
	end;
  
	Procedure AddMe (
	  p_snum Students.snum%type, p_callnum SchClasses.callnum%type) is
	  v_snum Students.snum%type;  
	  v_valid_capacity_msg varchar2(50);
	  v_valid_limit_msg varchar2(50);
	  v_error_msg varchar2(100);    
	  begin	
		validate_callnum(p_callnum);		
		Begin
		select snum into v_snum from students where snum=p_snum;
		EXCEPTION  
		WHEN NO_DATA_FOUND THEN
			dbms_output.put_line('- Student #' || p_snum || ' is invalid'); 
		End;
		begin
		Check_Capacity(p_snum, p_callnum, v_valid_capacity_msg);
		Check_Unit_Limit(p_snum, p_callnum, v_valid_limit_msg); 
			IF v_valid_capacity_msg is null Then
				If v_valid_limit_msg is null then
					
					Insert into enrollments values (p_snum, p_callnum, null);				
					commit;
					v_error_msg := null;
				Else 
					v_error_msg := v_valid_limit_msg;
				End If;
			Else
				if v_valid_limit_msg is null then				
					v_error_msg := v_valid_capacity_msg;				
				else 
					v_error_msg :=  v_valid_capacity_msg || ', and ' || v_valid_limit_msg;
				end if;		
			End If;
			IF v_error_msg is null THEN
				 dbms_output.put_line('Enrolled Successfully');
			ELSE
				 dbms_output.put_line('->- ' || v_error_msg);
			END IF;	
			Exception
					When DUP_VAL_ON_INDEX Then
							dbms_output.put_line('- duplicate enrollment record');
					When OTHERS Then
							null;
			end;
	  end;
End ENROLL;
/
show error;
pause;
Exec ENROLL.AddMe('102', 10120);
Exec ENROLL.AddMe('102', 10119);
Exec ENROLL.AddMe('119', 10110);
Exec ENROLL.AddMe('119', 10119);
Exec ENROLL.AddMe('102', 10110);
Spool off;
select * from enrollments;