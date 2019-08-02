Set echo on;
spool d:hw3spool.sql;
/* Exericise 2.3 page 44 */
Create or replace procedure Buy3Get1 (
  itemCount number) as
    v_result number;
  begin
    v_result := itemCount - trunc(itemCount/4);
    dbms_output.put_line('Thankyou, SELECT ' || itemCount || ', PAY FOR ' || v_result || ' items.');
  end;
/
show err;
Pause;
Exec Buy3Get1(5);
Exec Buy3Get1(12);
Exec Buy3Get1(20);
Exec Buy3Get1(21);
/* Exericise 2.8 page 45 */
Create or replace procedure MyRemoveOne (
  p_text varchar2,
  p_char_1 varchar2
  ) as
    v_char1_position number;
    v_text_length number;
    v_remove_result varchar2(30);
  begin
  v_text_length := length(p_text);
  v_char1_position := instr(p_text, p_char_1);
  v_remove_result := substr(p_text, 1, v_char1_position - 1) || substr(p_text, v_char1_position +1, v_text_length- v_char1_position);
  dbms_output.put_line('RESULT: ' || v_remove_result);
  end;
/
show err;
Pause;
Exec MyRemoveOne('SUV-339972','-');
Exec MyRemoveOne('WAP21*55499','*');
Exec MyRemoveOne('GAT2013#0930','#');
Spool off;