#!jinja 

create or replace view {{ database }}.CI_CD.VW_CUSTOMER as
SELECT * FROM {{ database }}.CI_CD.CUSTOMERS  ;
