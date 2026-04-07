
-- view entire table
select * from claims;

-- columns to be used
create view staging_tbl as
select 
	DESYNPUF_ID,
	CLM_ID,
	CLM_FROM_DT,
	ICD9_DGNS_CD_1,
	HCPCS_CD_1,
	LINE_NCH_PMT_AMT_1,
	LINE_ALOWD_CHRG_AMT_1
from claims;

-- qc for duplicate claims
with rn_tbl as (
	select 
		DESYNPUF_ID,
		CLM_ID,
		CLM_FROM_DT,
		ICD9_DGNS_CD_1,
		HCPCS_CD_1,
		LINE_NCH_PMT_AMT_1,
		LINE_ALOWD_CHRG_AMT_1,
		row_number() over (partition by DESYNPUF_ID,CLM_ID,CLM_FROM_DT, HCPCS_CD_1 order by CLM_ID) as rn
	from staging_tbl
)
 select
 	DESYNPUF_ID,
	CLM_ID,
	CLM_FROM_DT,
	ICD9_DGNS_CD_1,
	HCPCS_CD_1,
	LINE_NCH_PMT_AMT_1,
	LINE_ALOWD_CHRG_AMT_1
 from rn_tbl 
 where rn = 1;

-- check for blank data
select *
from staging_tbl
where
	DESYNPUF_ID is null or DESYNPUF_ID = ''
	or CLM_ID is null or CLM_ID = ''
	or CLM_FROM_DT is null or CLM_FROM_DT = ''
	or ICD9_DGNS_CD_1 is null or ICD9_DGNS_CD_1 = ''
	or HCPCS_CD_1 is null or HCPCS_CD_1 = '';
	

-- check where payment > allowable
select *
from staging_tbl 
where
	LINE_NCH_PMT_AMT_1  > LINE_ALOWD_CHRG_AMT_1 ;

-- check if there are any anomalies in allowable charge
with avg_tbl as (
	select 
		DESYNPUF_ID,
		CLM_ID,
		CLM_FROM_DT,
		ICD9_DGNS_CD_1,
		HCPCS_CD_1,
		LINE_NCH_PMT_AMT_1,
		LINE_ALOWD_CHRG_AMT_1,
		AVG(nullif(LINE_ALOWD_CHRG_AMT_1, 0)) over (partition by HCPCS_CD_1) as avg_allwd
	from staging_tbl
	where HCPCS_CD_1 is not null
)

-- This query is checking for any allowable charge that is more than 50% higher than avg for treatment
select *
from avg_tbl
where LINE_ALOWD_CHRG_AMT_1 >= avg_allwd * 1.5;


