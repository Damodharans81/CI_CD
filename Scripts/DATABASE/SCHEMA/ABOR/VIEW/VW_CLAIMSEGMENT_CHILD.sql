#!jinja 

create or replace view {{ database }}.ABOR.VW_CLAIMSEGMENT_CHILD(
	CLAIMID,
	SEGMENTID
) as select CLAIMID,
	SEGMENTID from claimsegment;