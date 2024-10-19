create or replace procedure {{dbname}}.IBOR.SP_GetCustomers()
returns table (Id number, Name varchar)
language sql
as
declare
  res resultset default (Select ID,first_name from ibor.customer limit 10);
begin
  return table(res);
end;