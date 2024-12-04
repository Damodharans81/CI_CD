#!jinja 

create or replace view {{ database }}.CI_CD.VW_CUSTOMER_NEW(
	CUSTOMER_ID,
	FIRST_NAME,
	LAST_NAME,
	PHONE_NO,
	EMAIL,
	STATE,
	AGE,
	LAST_MODIFIED_DATE
) as
SELECT * FROM {{ database }}.CI_CD.VW_CUSTOMER;