Set echo on;
spool d:hw4spool.sql;
/* Exericise 2.17 page 49 */
Create or replace procedure GetChange (
  p_AmountDue number, p_Pay number) as
    v_change number;
	v_count number;
	v_remainder number;
  begin
    IF 	p_AmountDue=p_Pay THEN
		dbms_output.put_line('You just gave me exact change! Thank you!');	
	ELSIF p_AmountDue > p_Pay THEN
		dbms_output.put_line('You need to give me more money!');	
	ELSE
		v_change := p_Pay - p_AmountDue;
		v_count := trunc(v_change/20);
		v_remainder := mod(v_change, 20);
		If v_count > 0 Then
			dbms_output.put_line(v_count || ' Twenty Dollar Bill');	
		End If;
		
		v_change := v_remainder;
		v_count := trunc(v_change/10);
		v_remainder := mod(v_change, 10);
		If v_count > 0 Then
			dbms_output.put_line(v_count || ' Ten Dollar Bill');	
		End If;
		
		v_change := v_remainder;
		v_count := trunc(v_change/5);
		v_remainder := mod(v_change, 5);
		If v_count > 0 Then
			dbms_output.put_line(v_count || ' Five Dollar Bill');	
		End If;
		
		If v_remainder > 0 Then
			dbms_output.put_line(v_remainder || ' One Dollar Bill');	
		End If;		
	END IF;    
  end;
/
show err;
Pause;
Exec GetChange(45, 45);
Exec GetChange(110, 100);
Exec GetChange(12,200);
Exec GetChange(95,200);
/* Exericise 2.21 page 52 */
Create or replace procedure LoveWizard (
  p_MagicNumber number) as
    v_temp number;
begin
	FOR i IN 1..p_MagicNumber LOOP
		v_temp := mod(i,2);
		IF v_temp = 1 THEN
			dbms_output.put_line('He loves you...');
		ELSE
			dbms_output.put_line('He loves you not...');
		END If;
	END LOOP;
	IF v_temp = 1 THEN
			dbms_output.put_line('===> He loves you!!!');
		ELSE
			dbms_output.put_line('===> He loves you not :-(');
		END If;

    
end;
/
show err;
Pause;
Exec LoveWizard(7);
Exec LoveWizard(8);
Spool off;