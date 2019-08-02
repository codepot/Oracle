Set echo on;
spool d:hw10spool.sql;
/* HOMEWORK 10 (Exercise #7.2 - PAGE 88*/

Create or replace TRIGGER AfterUpdateGPA 
after update on Students
for each row
Begin
	If :old.gpa-:new.gpa >= 1 Then
		dbms_output.put_line('new GPA is lower than the previous one at least 1 point');
	End If;
End;
/
show error;
pause;
update students set gpa=2.5 where snum='101';
update students set gpa=2.3 where snum='104';
update students set gpa=3.2 where snum='106';
update students set gpa=1.8 where snum='105';
Spool off;
