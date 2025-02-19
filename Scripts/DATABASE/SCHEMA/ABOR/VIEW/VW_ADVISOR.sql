#!jinja 

create or replace view {{ database }}.ABOR.VW_ADVISOR(
	ID,
	NAME,
	ROLE,
	CREATED_DATE,
	UPDATE_BY
) as
select ID,
	NAME,
	ROLE,
	CREATED_DATE,
	UPDATE_BY from {{ database }}.ABOR.Advisor;