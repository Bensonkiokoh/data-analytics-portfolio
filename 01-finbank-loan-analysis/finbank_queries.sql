-- ============================================
-- FINBANK LOAN PORTFOLIO ANALYSIS
-- Analyst: Benson Kioko
-- Tool: SQL Server Management Studio
-- Date: 2024
-- Description: Exploratory data analysis of
-- FinBank consumer loan portfolio covering
-- portfolio health, repayment behaviour,
-- agent performance, and customer retention.
-- ============================================

USE FinBank;
GO

-- ============================================
-- QUERY 1: Portfolio Health Overview
-- Business Question: What is the overall health
-- of the loan portfolio? How are loans
-- distributed by status and what percentage
-- does each represent by count and value?
-- ============================================

WITH LoansDisbursed AS (
    SELECT
        status,
        COUNT(*)          AS TotalLoans,
        SUM(loan_amount)  AS TotalLoanAmount
    FROM Loans
    GROUP BY status
)
SELECT
    status,
    TotalLoans,
    TotalLoanAmount,
    ROUND(TotalLoanAmount * 100.0 / SUM(TotalLoanAmount) OVER(), 2) AS StatusPercentage,
    ROUND(TotalLoans     * 100.0 / SUM(TotalLoans)      OVER(), 2) AS CountPercentage
FROM LoansDisbursed
ORDER BY StatusPercentage DESC;

-- Finding: Of all concluded loans (Closed + Defaulted),
-- 4 out of 5 ended in default -- an 80% default rate
-- on completed loans. Average defaulted loan is
-- KES 20,000 vs KES 264,400 for active loans.


-- ============================================
-- QUERY 2: Repayment Behaviour
-- Business Question: What percentage of all
-- repayments are On Time, Late, and Missed?
-- Which customers are driving the problems?
-- ============================================

-- Part A: Overall repayment breakdown
WITH RepaymentStatus AS (
    SELECT
        payment_status,
        COUNT(*) AS TotalPayments
    FROM Repayments
    GROUP BY payment_status
)
SELECT
    payment_status,
    TotalPayments,
    ROUND(TotalPayments * 100.0 / SUM(TotalPayments) OVER(), 2) AS RepaymentPercentage
FROM RepaymentStatus
ORDER BY RepaymentPercentage DESC;

-- Part B: Repayment breakdown per customer
SELECT
    C.full_name,
    C.credit_score,
    C.employment_status,
    COUNT(CASE WHEN R.payment_status = 'On Time' THEN 1 END) AS OnTime,
    COUNT(CASE WHEN R.payment_status = 'Late'    THEN 1 END) AS Late,
    COUNT(CASE WHEN R.payment_status = 'Missed'  THEN 1 END) AS Missed
FROM Loans L
INNER JOIN Customers C  ON L.customer_id  = C.customer_id
INNER JOIN Repayments R ON L.loan_id      = R.loan_id
GROUP BY C.full_name, C.credit_score, C.employment_status
ORDER BY Missed DESC;

-- Finding: 32.5% of repayments are Late or Missed --
-- triple the industry benchmark of 10%. All customers
-- with Missed payments have credit scores below 550
-- and unstable employment. None made a single payment,
-- indicating a credit approval failure, not collections.


-- ============================================
-- QUERY 3: Default Rate by Loan Type
-- Business Question: Which loan products carry
-- the highest default risk?
-- ============================================

SELECT
    loan_type,
    COUNT(*)                                                    AS LoansIssued,
    COUNT(CASE WHEN status = 'Defaulted' THEN 1 END)           AS DefaultedLoans,
    ROUND(
        COUNT(CASE WHEN status = 'Defaulted' THEN 1 END)
        * 100.0 / COUNT(*),
    2)                                                          AS DefaultRatePct
FROM Loans
GROUP BY loan_type
ORDER BY DefaultRatePct DESC;

-- Finding: Personal loans carry a 33% default rate.
-- Business loans and mortgages show zero defaults.
-- Personal loans are unsecured and approved for
-- customers with credit scores as low as 460.
-- Recommendation: minimum credit score of 600
-- and employment verification for personal loans.


-- ============================================
-- QUERY 4: Agent Performance
-- Business Question: How is each agent
-- performing on loans processed, value
-- disbursed, and processing speed?
-- ============================================

WITH LoansProcessed AS (
    SELECT
        agent_id,
        COUNT(*)                                                    AS TotalLoansProcessed,
        SUM(loan_amount)                                            AS TotalLoanAmount,
        AVG(DATEDIFF(DAY, application_date, disbursement_date))     AS AvgDays
    FROM Loans
    GROUP BY agent_id
)
SELECT
    A.agent_name,
    A.team,
    B.branch_name,
    LP.TotalLoanAmount,
    LP.TotalLoansProcessed,
    LP.AvgDays
FROM Agents A
INNER JOIN Branches B     ON A.branch_id = B.branch_id
LEFT  JOIN LoansProcessed LP ON A.agent_id = LP.agent_id
ORDER BY TotalLoanAmount DESC;

-- Finding: Carol Njeri leads on value (KES 1.84M).
-- Alice Mwangi leads on volume (5 loans).
-- Grace Akinyi leads on speed (3 days average).
-- David Kimani in Westlands processed zero loans
-- and requires immediate investigation.


-- ============================================
-- QUERY 5: Monthly Application Trend
-- Business Question: How has loan application
-- volume trended month by month?
-- ============================================

SELECT
    FORMAT(application_date, 'yyyy-MM') AS ApplicationMonth,
    COUNT(*)                            AS TotalApplications
FROM Loans
GROUP BY FORMAT(application_date, 'yyyy-MM')
ORDER BY MIN(application_date);

-- Finding: Applications held steady at 3-4 per month
-- from January to May 2024. August and September
-- show only 1 application each -- likely incomplete
-- data rather than a genuine business decline.
-- Full year data required before drawing conclusions.


-- ============================================
-- QUERY 6: Repeat Borrowers
-- Business Question: Which customers have taken
-- more than one loan? How long do they wait
-- between loans?
-- ============================================

WITH CustomersLoans AS (
    SELECT
        customer_id,
        COUNT(*)            AS TotalLoans,
        SUM(loan_amount)    AS TotalLoanAmount,
        MIN(application_date) AS FirstApplicationDate,
        MAX(application_date) AS RecentApplicationDate
    FROM Loans
    GROUP BY customer_id
    HAVING COUNT(*) > 1
)
SELECT
    C.full_name,
    CL.TotalLoanAmount,
    CL.TotalLoans,
    DATEDIFF(DAY, CL.FirstApplicationDate, CL.RecentApplicationDate) AS DaysBetweenLoans
FROM Customers C
INNER JOIN CustomersLoans CL ON C.customer_id = CL.customer_id
ORDER BY TotalLoanAmount DESC;

-- Finding: 5 repeat borrowers out of 20 customers
-- (25% repeat rate). Average gap between loans is
-- 150 days. Recommendation: re-engagement campaign
-- triggered at 120 days post-disbursement for
-- customers with clean repayment records.


-- ============================================
-- QUERY 7: Branch and Region Performance
-- Business Question: How does each branch
-- perform on total loans, value, and default rate?
-- ============================================

SELECT
    B.branch_name,
    B.region,
    COUNT(L.loan_id)                                                AS TotalLoans,
    COUNT(CASE WHEN status = 'Defaulted' THEN 1 END)               AS DefaultedLoans,
    ROUND(
        COUNT(CASE WHEN status = 'Defaulted' THEN 1 END)
        * 100.0 / COUNT(L.loan_id),
    2)                                                              AS DefaultRatePct,
    SUM(L.loan_amount)                                              AS TotalLoanAmount
FROM Loans L
INNER JOIN Agents A   ON L.agent_id   = A.agent_id
INNER JOIN Branches B ON A.branch_id  = B.branch_id
GROUP BY B.branch_name, B.region
ORDER BY DefaultRatePct DESC;

-- Finding: Nakuru carries an 80% default rate --
-- 4 out of 5 loans defaulted. All other branches
-- show zero defaults. Nairobi CBD disbursed
-- KES 2.69M with zero defaults and should serve
-- as the credit quality benchmark.


-- ============================================
-- QUERY 8: Agent Efficiency Ranking
-- Business Question: How do agents rank on
-- processing speed from application to
-- disbursement? DENSE_RANK used to correctly
-- handle tied performance.
-- ============================================

WITH AgentAvgProcessing AS (
    SELECT
        agent_id,
        AVG(DATEDIFF(DAY, application_date, disbursement_date)) AS AvgDays
    FROM Loans
    GROUP BY agent_id
)
SELECT
    A.agent_name,
    B.branch_name,
    A.team,
    AP.AvgDays,
    DENSE_RANK() OVER (ORDER BY AP.AvgDays ASC) AS AgentRank
FROM Agents A
INNER JOIN Branches B          ON A.branch_id = B.branch_id
INNER JOIN AgentAvgProcessing AP ON A.agent_id = AP.agent_id
ORDER BY AgentRank;

-- Note: David Kimani excluded via INNER JOIN since
-- he processed zero loans. A NULL average would rank
-- first with DENSE_RANK producing a misleading result.
-- Finding: Team A averages 4.8 days vs Team B 5.3 days.
-- Grace Akinyi fastest at 3 days. Carol Njeri slowest
-- at 8 days but handles complex high-value products --
-- context matters when reading efficiency metrics.