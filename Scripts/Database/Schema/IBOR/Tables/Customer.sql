CREATE or alter TABLE IBOR.Customer (
  sk_cid number not null AUTOINCREMENT PRIMARY KEY,, 
  first_name varchar, 
  last_name varchar,
  city varchar,
  state varchar,
  phone_number  varchar,
  IS_Active Bit,
  IS_Update vatchar,
  last_update_date TIMESTAMP default CURRENT_TIMESTAMP() 
);