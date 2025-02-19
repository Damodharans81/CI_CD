#!jinja 

CREATE or ALTER view {{ database }}.ABOR.VW_ADVISOR_ANALYST(
	ID,
	NAME,
	ROLE,
	CREATED_DATE,
	UPDATE_BY
) as
select * from {{ database }}.ABOR.Advisor where ROLE ilike '%Analyst%';