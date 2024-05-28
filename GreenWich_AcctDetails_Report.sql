SELECT 
    ACCT_NAME AS ACCOUNT_NAME,
    FORACID AS ACCOUNT_NUMBER,
    ACCT_OPN_DATE AS DATE_OPENED,
    SUBSTR(CIF_ID, 1, 1) AS INITIAL_CIF_ID,
    CASE 
        WHEN SUBSTR(CIF_ID, 1, 1) = 'R' THEN 'Retail Customer'
        WHEN SUBSTR(CIF_ID, 1, 1) = 'C' THEN 'Corporate Customer'
        ELSE 'Unidentified Customer'
    END AS ACCOUNT_TYPE,
    CASE 
        WHEN 'A' IN (SELECT ACCT_STATUS FROM tbaadm.smt WHERE acid = GAM.acid)
             OR 'A' IN (SELECT ACCT_STATUS FROM tbaadm.cam WHERE acid = GAM.acid) THEN 'Active'
        WHEN 'D' IN (SELECT ACCT_STATUS FROM tbaadm.smt WHERE acid = GAM.acid)
             OR 'D' IN (SELECT ACCT_STATUS FROM tbaadm.cam WHERE acid = GAM.acid) THEN 'Dormant'
        WHEN 'I' IN (SELECT ACCT_STATUS FROM tbaadm.smt WHERE acid = GAM.acid)
             OR 'I' IN (SELECT ACCT_STATUS FROM tbaadm.cam WHERE acid = GAM.acid) THEN 'Inactive'
        ELSE ''
    END AS ACCOUNT_STATUS,
     /* Below Line is Written to allow dynamic Query. Use to fetch balance as at 30th April 2023 - Change to fit Your Requirements */
    nvl((select TRAN_DATE_BAL from tbaadm.Eab where EOD_DATE ='30-APR-2023' and acid =GAM.acid),0) as APRIL_30TH_2023_BALANCE
     /* Below Line is Written to allow dynamic Query. Use to fetch balance as at TODAY - Uncomment it and Comment the Line above .....*/
    --nvl((select TRAN_DATE_BAL from tbaadm.Eab where EOD_DATE =(select db_stat_date from tbaadm.gct) and acid =GAM.acid),0) as BALANCE_AS_AT_TODAY
FROM 
    tbaadm.gam
WHERE 
    entity_cre_flg = 'Y' 
    AND del_flg = 'N'
    AND CIF_ID IS NOT NULL;