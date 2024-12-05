#!jinja 

create or replace view {{ database }}.CI_CD.VW_CUSTOMER_NEW as
SELECT * FROM {{ database }}.CI_CD.VW_CUSTOMER;
