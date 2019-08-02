/* 	STUDENT: PHUC CONG LE
	ID: #009587329
	TITLE: FINAL PROJECT
	CLASS: IS480, CSULB, FALL 2013
	PROFESSOR: SOPHIE LEE	*/	

Set echo on;
set linesize 200;
set pagesize 40;
clear screen;

drop table waitlist;
drop table enrollments;
drop table prereq;
drop table schclasses;
drop table courses;
drop table students;
drop table majors;


create table MAJORS
	(major varchar2(3) Primary key,
	mdesc varchar2(30));
insert into majors values ('ACC','Accounting');
insert into majors values ('FIN','Finance');
insert into majors values ('IS','Information Systems');
insert into majors values ('MKT','Marketing');

create table STUDENTS 
	(snum varchar2(3) primary key,
	sname varchar2(10),
	standing number(1),
	major varchar2(3) constraint fk_students_major references majors(major),
	gpa number(2,1),
	major_gpa number(2,1));

insert into students values ('101','Andy',4,'IS',2.8,3.2);
insert into students values ('102','Betty',2,null,3.2,null);
insert into students values ('103','Cindy',3,'IS',2.5,3.5);
insert into students values ('104','David',2,'FIN',3.3,3.0);
insert into students values ('105','Ellen',1,null,2.8,null);
insert into students values ('106','Frank',3,'MKT',3.1,2.9);
insert into students values ('107','Jim',2,'MKT',3.7,null);
insert into students values ('108','Susan',3,'MKT',3.5,3.4);
insert into students values ('109','Anna',3,'FIN',3.4,3.2);
insert into students values ('110','Jose',4,'MKT',3.2,3.5);
insert into students values ('111','Mary',4,'ACC',3.8,null);
insert into students values ('112','Lisa',2,'IS',3.5,3.6);
insert into students values ('113','Alex',2,null,3.2,null);
insert into students values ('114','Fillipe',3,'IS',3.3,3.3);
insert into students values ('115','Joven',3,'FIN',3.1,3.4);
insert into students values ('116','Camila',2,null,3.8,3.7);
insert into students values ('117','Mario',2,null,3.4,3.6);
insert into students values ('118','Ian',3,'FIN',2.4,3.2);
insert into students values ('119','Monica',4,'FIN',2.7,3.0);
insert into students values ('120','Claudia',3,'IS',3.9,3.7);
insert into students values ('121','Kelly',2,'ACC',3.4,3.5);
insert into students values ('122','Rosa',2,'MKT',3.1,null);
insert into students values ('123','Sam',2,null,3.7,3.5);
insert into students values ('124','Jason',3,'ACC',3.2,null);

create table COURSES
	(dept varchar2(3) constraint fk_courses_dept references majors(major),
	cnum varchar2(3),
	ctitle varchar2(30),
	crhr number(3),
	standing number(1),
	primary key (dept,cnum));

insert into courses values ('IS','300','Intro to MIS',3,2);
insert into courses values ('IS','301','Business Communicatons',3,2);
insert into courses values ('IS','310','Statistics',3,2);
insert into courses values ('IS','340','Business Application',3,3);
insert into courses values ('IS','355','Networks',3,3);
insert into courses values ('IS','380','Database',3,3);
insert into courses values ('IS','385','Systems',3,3);
insert into courses values ('IS','480','Adv Database',3,4);
insert into courses values ('FIN','300','Business Finance',3,3);
insert into courses values ('FIN','350','Investment Principles',3,3);
insert into courses values ('ACC','320','Cost Accounting',3,3);
insert into courses values ('ACC','470','Auditing',4,4);
insert into courses values ('MKT','300','Basic Marketing',3,2);

create table SCHCLASSES (
	callnum number(5) primary key,
	year number(4),
	semester varchar2(3),
	dept varchar2(3),
	cnum varchar2(3),
	section number(2),
	capacity number(3));

alter table schclasses 
	add constraint fk_schclasses_dept_cnum foreign key 
	(dept, cnum) references courses (dept,cnum);

insert into schclasses values (10110,2013,'Fa','IS','300',1,4);
insert into schclasses values (10115,2013,'Fa','IS','300',2,4);
insert into schclasses values (10120,2013,'Fa','IS','380',1,3);
insert into schclasses values (10121,2013,'Fa','IS','380',2,3);
insert into schclasses values (10125,2013,'Fa','IS','300',1,5);
insert into schclasses values (10130,2013,'Fa','IS','301',1,6);
insert into schclasses values (10131,2013,'Fa','IS','301',2,6);
insert into schclasses values (10135,2013,'Fa','IS','340',1,5);
insert into schclasses values (10141,2013,'Fa','FIN','300',1,4);
insert into schclasses values (10142,2013,'Fa','FIN','300',2,4);
insert into schclasses values (10145,2013,'Fa','FIN','350',2,5);
insert into schclasses values (10150,2013,'Fa','ACC','320',1,3);
insert into schclasses values (10160,2013,'Fa','MKT','300',1,3);
create table PREREQ
	(dept varchar2(3),
	cnum varchar2(3),
	pdept varchar2(3),
	pcnum varchar2(3),
	primary key (dept, cnum, pdept, pcnum));
alter table Prereq 
	add constraint fk_prereq_dept_cnum foreign key 
	(dept, cnum) references courses (dept,cnum);
alter table Prereq 
	add constraint fk_prereq_pdept_pcnum foreign key 
	(pdept, pcnum) references courses (dept,cnum);

insert into prereq values ('IS','380','IS','300');
insert into prereq values ('IS','380','IS','301');
insert into prereq values ('IS','380','IS','310');
insert into prereq values ('IS','385','IS','310');
insert into prereq values ('IS','355','IS','300');
insert into prereq values ('IS','480','IS','380');
insert into prereq values ('FIN','350','FIN','300');
insert into prereq values ('ACC','470','ACC','320');

create table ENROLLMENTS (
	snum varchar2(3) constraint fk_enrollments_snum references students(snum),
	callnum number(5) constraint fk_enrollments_callnum references schclasses(callnum),
	grade varchar2(2),
	primary key (snum, callnum));
create table Waitlist (
	snum varchar2(3) constraint fk_waitlist_snum references students(snum),
	callnum number(5) constraint fk_waitlist_callnum references schclasses(callnum),
	RequestTime TimeStamp, primary key (snum, callnum));
commit;

spool d:ProjectSpool.sql;
Create or Replace Package Enroll is
	Procedure AddMe (
	  p_snum IN Students.snum%type, p_callnum IN SchClasses.callnum%type, p_ErrorMsg OUT varchar2);
	
	Procedure DropMe (
	  p_snum Students.snum%type, p_callnum SchClasses.callnum%type);	
End Enroll;
/

Create or replace Package Body Enroll is
	-- condition #1.1a check for valid snum
	Function Func_validate_snum (
		p_snum Students.snum%type) return boolean is
		v_count number;
	BEGIN
		select count(snum) into v_count from students where snum=p_snum;	
		If v_count > 0 Then
			return True;
		Else
			return False;
		End If;	
	END;  
	
	-- condition #1.1b check for valid callnum
	Function Func_validate_callnum (
		p_callnum SchClasses.callnum%type) return boolean is
		v_count number;
	BEGIN
		select count(callnum) into v_count from SchClasses where callnum=p_callnum;	
		If v_count > 0 Then
			return True;
		Else
			return False;
		End If;	
	END; 
	
	-- condition #1.2 check for Double Enrollment
	Function Func_Check_Double_Enroll (
		p_snum Students.snum%type, p_callnum SchClasses.callnum%type) return varchar2 is
		v_dept SchClasses.DEPT%Type;
		v_cnum SchClasses.CNUM%Type;		
		v_count number;
	  begin
		select DEPT into v_dept from SchClasses where callNum=p_callnum;
		select CNUM into v_cnum from SchClasses where callNum=p_callnum;		
		select count (snum) into v_count from Enrollments e, Schclasses s Where e.snum=p_snum AND Dept=v_dept AND cnum=v_cnum and e.callnum=s.callnum;
		If v_count > 0 Then			
			return 'double enrollment error';						
		End If;
		return null;
		end;
	 
	-- condition #1.3 check for Undeclared Major 
	Function Func_Check_Undeclared_Major (
		p_snum Students.snum%type, p_callnum SchClasses.callnum%type) return varchar2 is
		v_major Students.Major%Type;
		v_cnum SchClasses.CNUM%Type;
		v_cnumInitial SchClasses.CNUM%Type;
	begin
		select NVL(Major,'NA') into v_major from Students where snum=p_snum;
		select CNUM into v_cnum from SchClasses where callNum=p_callnum;
		v_cnumInitial := substr(v_cnum,1,1);
		If v_cnumInitial = '3' or v_cnumInitial = '4' Then
			if v_major = 'NA' then
				return 'Undelared major student cannot enroll major course';				
			end if;		
		End If;	
		return null;
	end;

	-- condition #1.4 check for 15-Hour Rule
	Function Func_Check_15Hour_Rule (
		p_snum IN Students.snum%type,
		p_callnum IN SchClasses.callnum%type) return varchar2 is
		v_unit number;
		v_Unit_registered number;
	begin
		select CRHR into v_unit from courses c, schclasses s where callnum=p_callnum AND s.dept=c.dept AND s.cnum=c.cnum;
		-- Sum credit hours of all null-grade classes only, graded class aren't counted
		select sum(CRHR) into v_Unit_registered from courses c, schclasses s, enrollments e where e.snum=p_snum 
		AND e.callnum = s.callnum AND s.dept = c.dept AND s.cnum = c.cnum and e.grade is null;    
		-- make deciscion	
		If v_unit + v_Unit_registered > 15 Then
			return '15 units exceeded';
		End If;	
		return null;
	end;
	
	-- condition #1.5 check for Standing Requirement
	Function Func_Check_Standing( 
		p_snum IN Students.snum%type,
		p_callnum IN Schclasses.callnum%type) return varchar2 is	
		v_studentStanding Students.standing%type;
		v_courseStanding Courses.standing%type;
	Begin
		Select Standing into v_studentStanding from students where snum= p_snum;
		Select c. Standing into v_courseStanding from courses c, schclasses s where s.callnum = p_callnum AND s.dept = c.dept AND s.cnum = c.cnum;
		If v_studentStanding < v_courseStanding Then
			return 'standing requirement has not met';
		End If;	
		return null;
	End;
	
	-- condition #1.6 check for Class Capacity, return TRUE if class still have room
	Function Func_Check_Capacity (p_callnum IN SchClasses.callnum%type) return boolean is
		v_capacity number;
		v_registered number;
	begin	
		select capacity into v_capacity from SchClasses where callNum=p_callnum;	
		Select count(Snum) into v_registered from enrollments where callnum=p_callnum and Grade is null;    
		If v_registered < v_capacity Then
			return TRUE;
		Else
			return FALSE;
		End If;	
	end;
	
	-- condition #1.7 check for Prerequisites
	Function Func_Check_Prerequisites (
		p_snum Students.snum%type, 
		p_callnum SchClasses.callnum%type) return varchar2 is
		v_dept SchClasses.DEPT%Type;
		v_cnum SchClasses.CNUM%Type;
		v_count number;
	begin
		select DEPT into v_dept from SchClasses where callNum=p_callnum;
		select CNUM into v_cnum from SchClasses where callNum=p_callnum;
		
		Select count(DEPT) into v_count from (select pDept as DEPT, PCnum as CNUM from PreReq where dept=v_dept and cnum=v_cnum
		MINUS Select DEPT, CNUM from schclasses s, enrollments e where e.snum=p_snum and s.callnum = e.callnum and GRADE in ('A','B','C', 'D'));
		If v_count > 0 Then
			return 'Prerequisite has not been met';			
		End If;	
		return null;
	end;
	
	-- sub function
	Function Append_Messages(OldMessage varchar2, NewMessage varchar2) return varchar2 is
	Begin
		If OldMessage is null Then
			return NewMessage;
		Else
			If NewMessage is null Then
				return OldMessage;
			Else
				return OldMessage || ', ' || NewMessage;
			End If;				
		End If;
	End;
	
		-- sub procedure
	Procedure Pro_Add_to_Waitlist (
		p_snum Students.snum%type, 
		p_callnum SchClasses.callnum%type) is
		v_count number;
	Begin
		Select count(Snum) into v_count from Waitlist where snum=p_snum and callnum=p_callnum; 		
		If v_count > 0 then		
			dbms_output.put_line ('Student ' || p_snum ||' is still in waitlist for ' || p_callnum);
		Else
			insert into Waitlist values (p_snum,p_callnum, SysTimeStamp);
			commit;
			dbms_output.put_line ('The class was full, and you are added to waitlist for ' || p_callnum);
		End If;		
	End;
	
	-- sub procedure
	Procedure Pro_Enroll (
		p_snum Students.snum%type, 
		p_callnum SchClasses.callnum%type) is
		v_count number;
	Begin
		-- to make sure this student have not ever enrolled this class before
		Select count(Snum) into v_count from Enrollments where snum=p_snum and callnum=p_callnum; 
		If v_count = 0 then				
			insert into Enrollments values (p_snum, p_callnum, NULL);	
			dbms_output.put_line ('Student ' || p_snum || ' has just successfully enrolled in ' || p_callnum);
			commit;
		Else
			dbms_output.put_line ('You have already enrolled ' || p_callnum || ' before');
		End If;
			
	End;	 
	
	Procedure AddMe (
		p_snum Students.snum%type, p_callnum SchClasses.callnum%type, p_ErrorMsg OUT varchar2) is  
		v_valid_snum boolean;
		v_valid_callnum boolean;
		v_available_room boolean;	
		v_error varchar2(300);
		v_double_enroll_error varchar2(60);
		v_undeclared_major_error varchar2(60);
		v_15hour_rule_error varchar2(60);
		v_standing_error varchar2(60);
		v_prerequisite_error varchar2(60);
		
	BEGIN
		v_available_room:= false;
		v_valid_snum := Func_validate_snum(p_snum);
		v_valid_callnum := Func_validate_callnum(p_callnum);
		IF v_valid_snum AND v_valid_callnum THEN
			v_error := null;
			v_double_enroll_error := Func_Check_Double_Enroll(p_snum, p_callnum);
			v_undeclared_major_error := Func_Check_Undeclared_Major(p_snum, p_callnum);
			v_15hour_rule_error := Func_Check_15Hour_Rule(p_snum, p_callnum);
			v_standing_error := Func_Check_Standing(p_snum, p_callnum);
			v_prerequisite_error := Func_Check_Prerequisites(p_snum, p_callnum);
			v_error := Append_Messages(v_error, v_double_enroll_error);			
			v_error := Append_Messages(v_error, v_undeclared_major_error);			
			v_error := Append_Messages(v_error, v_15hour_rule_error);			
			v_error := Append_Messages(v_error, v_standing_error);
			v_error := Append_Messages(v_error, v_prerequisite_error);			
			If v_error is null Then
				v_available_room := Func_Check_Capacity(p_callnum);
				if v_available_room then
					-- ADD TO ENROLLMENT
					Pro_Enroll (p_snum, p_callnum);
				else
					-- ADD TO WAITLIST
					Pro_Add_to_Waitlist(p_snum, p_callnum);
				end if;				
			Else
				p_ErrorMsg := 'Enrollment error: ' || v_error;
				dbms_output.put_line (p_ErrorMsg);
			End If;			
		ELSE
			If v_valid_snum Then
				p_ErrorMsg := p_callnum || ' is not valid';
			Elsif v_valid_callnum Then
				p_ErrorMsg := p_snum || ' is not valid';
			Else
				p_ErrorMsg := p_snum || ' is not valid , and ' || p_callnum || ' is not valid, either';
			End If;	
			dbms_output.put_line ('Enrollment error: ' || p_ErrorMsg);
		END IF;
		 
	END;	
	
	-- sub procedure for dropme
	Procedure proceed_waitlist (
		p_snum Students.snum%type, p_callnum SchClasses.callnum%type) is
		CURSOR cWaitlist is select snum, callnum from Waitlist where callnum=p_callnum order by requestTime;
		v_addClass_error varchar2(300);
	BEGIN
		FOR EachWait IN cWaitlist LOOP
			v_addClass_error := null;
			AddMe(EachWait.snum, p_callnum, v_addClass_error);
			If v_addClass_error is Null then
				delete from waitlist where snum=EachWait.snum and callnum=p_callnum;
				commit;
				exit;
			End If;
		END LOOP;
	END;
  
	Procedure DropMe (
		p_snum Students.snum%type, p_callnum SchClasses.callnum%type) is
		v_ErrorMsg varchar2(60);
		v_valid_snum boolean;
		v_valid_callnum boolean;
		v_count number;
	BEGIN
		v_valid_snum := Func_validate_snum(p_snum);
		v_valid_callnum := Func_validate_callnum(p_callnum);
		
		IF v_valid_snum AND v_valid_callnum THEN
			-- 2. a student can only drop if he is enrolled in class that grade has not been assigned
			select count (snum) into v_count from Enrollments  where snum=p_snum AND callnum=p_callnum AND grade is null;
			If v_count>0 Then
				-- 3 withdraws with a 'W'
				update enrollments set Grade='W' where snum=p_snum AND callnum=p_callnum;
				commit;
				dbms_output.put_line (p_snum || ' has just successfully dropped  ' || p_callnum);
				proceed_waitlist(p_snum, p_callnum);
			Else
				dbms_output.put_line ('Class Dropping Error: Grade was assigned or this student has not ever enrolled in this class!');
			End If;
		ELSE
			If v_valid_snum Then
				v_ErrorMsg := p_callnum || ' is not valid';
			Elsif v_valid_callnum Then
				v_ErrorMsg := p_snum || ' is not valid';
			Else
				v_ErrorMsg := p_snum || ' is not valid , and ' || p_callnum || ' is not valid, either';
			End If;	
			dbms_output.put_line ('Class Dropping Error: ' || v_ErrorMsg);
		END IF;		
	END;
End Enroll;
/
show error;
pause;
Spool off;