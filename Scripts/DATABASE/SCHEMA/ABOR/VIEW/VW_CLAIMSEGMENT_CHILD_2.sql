#!jinja 

create or replace view {{ database }}.ABOR.VW_CLAIMSEGMENT_CHILD_2(
	CLAIMID,
	SEGMENTID,
	RECORD_DATE
) as select * from claimsegment;