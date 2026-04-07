# Medical Claims Audit

## Overview
**Goal:** Clean and validate Medicare claims data and flag payment discrepancies.

**Key Steps:**
- Extracted relevant claim columns into a staging table.
- Removed duplicate claims to ensure unique records.
- Checked for missing or blank fields in critical columns.
- Flagged payment anomalies where payment exceeded allowed charges.
- Flagged allowable charge anomalies where allowable charge for a treatment is more than 50% above average.

---

## Dataset
The dataset used for this project comes from **Data Entrepreneurs' Synthetic Public Use Files (DE-SynPUF)**.  

**Download Link:**  
[CMS DE-SynPUF Sample 1](https://www.cms.gov/data-research/statistics-trends-and-reports/medicare-claims-synthetic-public-use-files/cms-2008-2010-data-entrepreneurs-synthetic-public-use-file-de-synpuf/de10-sample-1)

**Columns of Interest:**
- `DESYNPUF_ID` – Patient identifier  
- `CLM_ID` – Claim identifier  
- `CLM_FROM_DT` – Claim start date  
- `ICD9_DGNS_CD_1` – Primary diagnosis code  
- `HCPCS_CD_1` – Procedure code  
- `LINE_NCH_PMT_AMT_1` – Payment amount for the line item  
- `LINE_ALOWD_CHRG_AMT_1` – Allowed charge amount for the line item  

---

## Project Steps – Quick Walkthrough

### 1. View the Entire Table
Reviewed all claims to understand the raw data.

### 2. Create Staging Table
Isolated the key columns for streamlined analysis.

### 3. Remove Duplicates
Ensured each claim record is unique to prevent double counting.

### 4. Check for Missing/Blank Data
Identified rows with empty or null critical fields for data quality.

### 5. Check Payment vs Allowed Charge
Flagged records where payment exceeded the allowed amount.

### 6. Detect Allowable Charge Anomalies
Calculated the average allowable charge per procedure code and flagged records where the allowable charge was more than 50% higher than the treatment average. This helps identify potential billing inconsistencies or outliers.


## Next Steps
### A. Investigate root causes 
Determine if anomalies are due to data entry errors, coding mistakes, or unusual billing practices.

### B. Communicate with relevant personnel 
Share the flagged claims with the billing or compliance team for corrective action.

### C. Update processes 
Recommend any data validation or monitoring improvements to reduce similar anomalies in future claims.