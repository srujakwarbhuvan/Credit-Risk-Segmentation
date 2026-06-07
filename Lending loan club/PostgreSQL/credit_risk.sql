SELECT COUNT(*) FROM loans;

SELECT loan_status, is_default, COUNT(*) 
FROM loans 
GROUP BY loan_status, is_default 
ORDER BY COUNT(*) DESC;


CREATE OR REPLACE VIEW loans_scored AS
SELECT *,
    CASE 
        WHEN fico_range_low >= 750 THEN 1
        WHEN fico_range_low >= 700 THEN 2
        WHEN fico_range_low >= 650 THEN 3
        ELSE 4
    END AS fico_score,

	CASE 
        WHEN dti < 10 THEN 1
        WHEN dti < 20 THEN 2
        WHEN dti < 30 THEN 3
        ELSE 4
    END AS dti_score,

	 CASE 
        WHEN revol_util < 25 THEN 1
        WHEN revol_util < 50 THEN 2
        WHEN revol_util < 75 THEN 3
        ELSE 4
    END AS revol_score,

	 CASE 
        WHEN grade = 'A' THEN 1
        WHEN grade = 'B' THEN 2
        WHEN grade = 'C' THEN 3
        WHEN grade IN ('D','E','F','G') THEN 4
    END AS grade_score,

    CASE 
        WHEN delinq_2yrs = 0 THEN 1
        WHEN delinq_2yrs = 1 THEN 2
        WHEN delinq_2yrs = 2 THEN 3
        ELSE 4
    END AS delinq_score

FROM loans;


SELECT 
    fico_score, dti_score, revol_score, grade_score, delinq_score,
    (fico_score + dti_score + revol_score + grade_score + delinq_score) AS total_score
FROM loans_scored
LIMIT 5;


CREATE OR REPLACE VIEW loans_tiered AS
SELECT *,
    (fico_score + dti_score + revol_score + grade_score + delinq_score) AS total_score,
    CASE 
        WHEN (fico_score + dti_score + revol_score + grade_score + delinq_score) <= 8  THEN 'Low Risk'
        WHEN (fico_score + dti_score + revol_score + grade_score + delinq_score) <= 12 THEN 'Medium Risk'
        WHEN (fico_score + dti_score + revol_score + grade_score + delinq_score) <= 16 THEN 'High Risk'
        ELSE 'Critical Risk'
    END AS risk_tier
FROM loans_scored;

SELECT 
    risk_tier,
    COUNT(*)                                            AS total_loans,
    ROUND(AVG(is_default::numeric) * 100, 2)           AS default_rate_pct,
    ROUND(AVG(loan_amnt)::numeric, 0)                  AS avg_loan_amount,
    ROUND(AVG(int_rate)::numeric, 2)                   AS avg_interest_rate,
    ROUND(AVG(annual_inc)::numeric, 0)                 AS avg_annual_income,
    ROUND(AVG(dti)::numeric, 2)                        AS avg_dti,
    ROUND(AVG(fico_range_low)::numeric, 0)             AS avg_fico
FROM loans_tiered
GROUP BY risk_tier
ORDER BY default_rate_pct DESC;

SELECT 
    purpose,
    COUNT(*)                                    AS total_loans,
    ROUND(AVG(is_default::numeric) * 100, 2)   AS default_rate_pct,
    ROUND(AVG(int_rate)::numeric, 2)            AS avg_interest_rate
FROM loans_tiered
GROUP BY purpose
ORDER BY default_rate_pct DESC;

SELECT 
    risk_tier,
    grade,
    COUNT(*)                                    AS total_loans,
    ROUND(AVG(is_default::numeric) * 100, 2)   AS default_rate_pct
FROM loans_tiered
GROUP BY risk_tier, grade
ORDER BY risk_tier, default_rate_pct DESC;
