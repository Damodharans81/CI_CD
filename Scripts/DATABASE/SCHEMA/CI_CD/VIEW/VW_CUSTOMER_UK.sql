#!jinja 

create or replace view {{ database }}.CI_CD.VW_CUSTOMER_UK as
SELECT * FROM {{ database }}.CI_CD.VW_CUSTOMER;
