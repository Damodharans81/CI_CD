#!jinja 

create or replace view {{ database }}.ABOR.VW_ADVISOR(
	ID,
	NAME,
	ROLE,
	CREATED_DATE,
	UPDATE_BY
) as
select * from {{ database }}.ABOR.Advisor;