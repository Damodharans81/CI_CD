#!jinja 

create or replace TABLE {{ database }}.ABOR.ADVISOR (
	ID NUMBER(38,0) autoincrement start 1 increment 1 noorder,
	NAME VARCHAR(100) NOT NULL,
	ROLE VARCHAR(100),
	DEPARTMENT VARCHAR(1000),
	CREATED_AT TIMESTAMP_NTZ(9) DEFAULT CURRENT_TIMESTAMP()
);
