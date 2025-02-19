#!jinja 

create or replace view {{ database }}.ABOR.VW_CLAIMSEGMENT_CHILD_2(
	CLAIMID,
	SEGMENTID
) as select CLAIMID,
	SEGMENTID from claimsegment;