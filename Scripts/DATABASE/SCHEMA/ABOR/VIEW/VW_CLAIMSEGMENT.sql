#!jinja 

create or replace view {{ database }}.ABOR.VW_CLAIMSEGMENT(
	CLAIMID,
	SEGMENTID
) as select CLAIMID,
	SEGMENTID from claimsegment;