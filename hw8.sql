Set echo on;
spool d:hw8spool.sql;
/* HOMEWORK 8: Exercise 5.9 Page 73 */
Create or replace procedure Top3EachMajor as
	CURSOR cStudents is select snum, sname, major, gpa from students order by major, gpa desc;
	v_major varchar2(3);
	v_count number;
  Begin
	v_major := 'XYZ';
	v_count := 0;
	For eachStudent in cStudents Loop
		If v_major <> eachStudent.Major Then
			v_count := 0;
			v_major := eachStudent.Major;
		End If;		
		If v_count<3 then			
			insert into studentArchive values (eachStudent.Snum,eachStudent.sname,eachStudent.major,eachStudent.GPA);
			v_count := v_count + 1;			
		End If;		
	End Loop;
	commit;
  End;
/
show err;
Pause;
Exec Top3EachMajor();
select * from studentArchive;
spool off;
