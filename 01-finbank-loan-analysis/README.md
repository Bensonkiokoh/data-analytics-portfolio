# FinBank Loan Portfolio Analysis

## Business Context
FinBank is a consumer lending institution 
offering personal loans, business loans, 
and mortgages across five branches in Kenya.
The analysis was commissioned to understand 
portfolio health, agent performance, and 
credit risk patterns.

## Dataset
- 5 tables: Loans, Customers, Repayments, 
  Agents, Branches
- 25 loan records across 20 unique customers
- 10 agents across 5 branches
- Period: January to September 2024

## Business Questions Answered
1. What is the overall portfolio health by status?
2. What percentage of repayments are on time, 
   late, or missed?
3. Which loan type has the highest default rate?
4. How is each agent performing?
5. How has monthly application volume trended?
6. Which customers are repeat borrowers?
7. Which branch carries the highest default risk?
8. How do agents rank on processing efficiency?

## Key Findings
- 80% default rate on concluded loans
- All defaults concentrated in personal loans 
  under KES 30,000 issued to customers with 
  credit scores below 550
- Nakuru branch carries an 80% default rate 
  while all other branches show zero defaults
- Team A processes loans in 4.8 days vs 
  Team B at 5.3 days

## Skills Demonstrated
SQL Server, CTEs, Window Functions, CASE WHEN,
DATEDIFF, DENSE_RANK, Multi-table JOINs,
LEFT JOIN vs INNER JOIN decision making
```
