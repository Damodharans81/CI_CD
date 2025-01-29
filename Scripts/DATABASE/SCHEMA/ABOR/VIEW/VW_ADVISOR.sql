#!jinja 

create or replace view {{ database }}.ABOR.VW_ADVISOR(
	ID,
	NAME,
	ROLE,
	CREATED_AT
) as
select * from {{ database }}.ABOR.Advisor;