#!jinja 

create or replace view {{ database }}.ABOR.VW_CLAIMSEGMENT(
	CLAIMID,
	SEGMENTID
) as select * from claimsegment;