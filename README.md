# Credit Risk Segmentation & Loan Default Profiling

`PostgreSQL` `Python` `Excel` `Power BI`

End-to-end credit risk analysis on 88,560 real Lending Club loans. Built a weighted multi-factor scoring model across FICO, DTI, revolving utilization, loan grade, and delinquency history to segment borrowers into four risk tiers - with default rates ranging from 6.69% to 37.82% across segments.

**Dataset:** [Lending Club Loan Data - Kaggle](https://www.kaggle.com/datasets/wordsforthewise/lending-club)

---

## Dashboard Walkthrough

### Page 1: Portfolio Overview
<img width="1102" height="629" alt="Portfolio Overview " src="https://github.com/user-attachments/assets/94174e3f-a633-4bf5-b2e6-3a2accbf4b6e" />


The portfolio contains 88,560 closed loans with a total disbursed value of $1.28 billion and an overall default rate of 20.67%. The average FICO score across the portfolio is 694 - sitting just inside the "Fair" credit range, which explains why default rates are elevated relative to prime lending benchmarks.

53.56% of all loans fall into the High Risk tier - the single largest segment. This is not a healthy distribution. A well-managed lending portfolio would have the majority of volume concentrated in Low and Medium Risk. The concentration in High Risk indicates either loose origination standards or a deliberate subprime lending strategy.

The default rate bar chart confirms the scoring model is working as intended: each tier is cleanly separated, with Critical Risk at 37.82% sitting more than double the Medium Risk rate of 17.13%.

---

### Page 2: Risk Tier Analysis
<img width="1092" height="619" alt="Risk Tier Analysis" src="https://github.com/user-attachments/assets/37d43e92-1f8e-4203-98c6-be15246111a2" />


Three patterns stand out across the risk tier breakdowns.

First, income drops sharply with risk. Low Risk borrowers earn an average of $91,405 annually - $22,000 more than Critical Risk borrowers at $69,692. Higher income is not just correlated with lower default; it directly increases repayment capacity and buffers against income shocks.

Second, interest rates move in the same direction as risk - but this creates a paradox. Critical Risk borrowers are charged 16.81% average interest versus 7.58% for Low Risk borrowers. Higher rates increase the monthly burden on the borrowers least equipped to carry it, compounding default probability rather than compensating for it.

Third, the DTI scatter plot shows clear tier separation. Low Risk borrowers (green) cluster at DTI values below 20. High and Critical Risk borrowers (red, dark red) spread across DTI values of 25–50+. The visual confirms DTI is a strong discriminator - but also shows significant overlap between Medium and High Risk tiers, which is expected in real-world data.

---

### Page 3: Loan Purpose Analysis
<img width="1092" height="616" alt="Loan Purpose Analysis" src="https://github.com/user-attachments/assets/0a902dcf-26d4-4d81-b008-1c02f4b87bbe" />


Loan purpose reveals a risk profile that is not obvious from borrower financials alone.

Small Business loans default at 31.1% - the highest of any purpose. This reflects the inherent volatility of business income relative to salaried employment. House purchase loans follow at 27.82%, likely driven by borrowers taking on more debt than their income can sustain at current interest rates.

The volume-risk disconnect is the most important finding on this page. Debt consolidation is by far the most common loan purpose at 50,058 loans - but it carries a 22.49% default rate. This means the largest segment of the portfolio is also a high-risk segment. Borrowers consolidating debt are already under financial stress at origination; the loan does not resolve the underlying problem, it restructures it.

Car loans default at only 15.57% - the lowest rate. The asset-backed nature of vehicle loans, combined with the practical necessity of keeping a car to maintain employment, drives repayment discipline.

---

### Page 4: Grade Analysis
<img width="1088" height="602" alt="Grade Analysis" src="https://github.com/user-attachments/assets/af06a869-fe27-4a1f-9e15-1f6a43fe3240" />


The grade analysis heatmap is the most analytically dense visual in the dashboard. It shows default rate at the intersection of loan grade (A through G) and risk tier - 28 cells, each representing a distinct borrower profile.

The gradient from green to dark red tells a clean story: risk compounds. Grade A borrowers in the Low Risk tier default at just 4.10%. Grade G borrowers in the High Risk tier default at 62.04%. That is a 15x difference between the safest and most dangerous segment in the portfolio.

Two anomalies are worth flagging. Grade F and G borrowers appear in the Low Risk tier - which seems contradictory. These are borrowers with poor LC-assigned loan grades but strong scores on the other four variables (FICO, DTI, utilization, delinquency). The scoring model correctly identifies them as lower risk than their grade alone would suggest, but the 0.00% default rate for Grade F Low Risk is based on a single loan and should not be interpreted as meaningful.

The loan count bar chart confirms Grade B and C dominate the portfolio at 28.1K and 24.7K loans respectively. Grade G has only 0.3K loans - statistically thin, but the 62.04% default rate in the High Risk tier is based on 245 loans, which is sufficient to be directionally reliable.

---

## Key Findings

- Default rate spans **6.69% to 37.82%** across risk tiers - a 5.6x difference
- **53.56% of the portfolio sits in High Risk** - the largest single tier by volume
- FICO score drops 71 points from Low Risk (742) to Critical Risk (671)
- Average income falls **$22,000** from Low Risk to Critical Risk borrowers
- **Small Business loans default at 31.1%** - highest of any purpose
- **Car loans default at 15.57%** - lowest of any purpose
- **Grade G + High Risk = 62.04% default rate** - most dangerous combination
- **Grade A + Low Risk = 4.10% default rate** - safest segment
- debt_consolidation dominates volume at 50K+ loans but carries 22.49% default rate

---

## Risk Scoring Model

Each applicant is scored across 5 variables on a 1–4 scale (1 = low risk, 4 = critical risk). Scores are summed to a total of 5–20, then bucketed into tiers.

| Risk Factor | Weight | Score 1 (Low) | Score 2 (Medium) | Score 3 (High) | Score 4 (Critical) |
|---|---|---|---|---|---|
| FICO Score | 25% | ≥750 | 700–749 | 650–699 | <650 |
| DTI Ratio | 25% | <10% | 10–20% | 20–30% | >30% |
| Revolving Utilization | 20% | <25% | 25–50% | 50–75% | >75% |
| Loan Grade | 20% | A | B | C | D–G |
| Delinquency (2yr) | 10% | 0 incidents | 1 incident | 2 incidents | 3+ incidents |

**Tier thresholds:** Score 5–8 = Low Risk · 9–12 = Medium Risk · 13–16 = High Risk · 17–20 = Critical Risk

---

## Results Summary

| Risk Tier | Total Loans | Default Rate | Avg FICO | Avg DTI | Avg Income |
|---|---|---|---|---|---|
| Critical Risk | 669 | 37.82% | 671 | 31.27 | $69,692 |
| High Risk | 28,908 | 31.65% | 678 | 24.22 | $70,760 |
| Medium Risk | 47,434 | 17.13% | 693 | 17.22 | $78,724 |
| Low Risk | 11,549 | 6.69% | 742 | 12.55 | $91,405 |

---

## Analytical Decisions

**Why rule-based scoring over ML:** The goal was an interpretable, auditable risk framework - not a black-box prediction model. A credit committee needs to explain to a regulator exactly why a loan was declined. Rule-based scoring with documented weights satisfies that requirement. ML would produce better accuracy but zero explainability at the decision level.

**Why Current loans were excluded:** Loans with status "Current" have no resolved outcome - they are neither defaulted nor fully paid. Including them in default rate calculations would dilute the signal. Only closed outcomes (Fully Paid, Charged Off, Late, Default, In Grace Period) were retained.

**Why 5 variables and not more:** The dataset has 150+ columns. The 5 selected variables - FICO, DTI, revolving utilization, loan grade, delinquency - are the five factors most consistently cited in credit risk literature and used in real-world scoring frameworks like FICO and VantageScore.

**Why PostgreSQL views over flat tables for scoring:** Risk scoring logic lives in SQL views rather than being hardcoded in Python. Scoring thresholds can be updated in one place and all downstream analysis reflects the change automatically. This mirrors how production risk systems are built.

**NULL handling for emp_length:** 6,112 records had no employment length. Filled as "Unknown" rather than dropped - dropping would have removed 6.9% of the dataset and introduced selection bias if missing employment data correlates with default behavior.

---

## Data Quality

| Issue | Finding | Action |
|---|---|---|
| `emp_length` nulls | 6,112 records (6.9%) | Filled with "Unknown" |
| `dti` nulls | 2 records | Dropped |
| `revol_util` nulls | 37 records | Dropped |
| `loan_status = Current` | 11,402 records - outcome unresolved | Excluded from analysis |
| Final clean dataset | 88,560 records · 20 features + 1 target | Ready for scoring |

---

## Repository Structure

```
credit-risk-segmentation/
├── data/
│   ├── loans_scored_full.csv
│   ├── tier_profile.csv
│   ├── purpose_profile.csv
│   └── grade_tier.csv
├── sql/
│   ├── 01_create_table.sql
│   ├── 02_risk_scoring_view.sql
│   └── 03_segment_profiling.sql
├── notebooks/
│   └── credit_risk_analysis.ipynb
├── excel/
│   └── credit_risk_scoring_matrix.xlsx
├── powerbi/
│   ├── credit_risk_dashboard.pbix
│   └── screenshots/
│       ├── Portfolio_Overview.png
│       ├── Risk_Tier_Analysis.png
│       ├── Loan_Purpose_Analysis.png
│       └── Grade_Analysis.png
└── README.md
```

---

## Tools & Technologies

- **Python** - pandas, matplotlib, seaborn, sqlalchemy, openpyxl
- **PostgreSQL** - data storage, risk scoring views, segment profiling queries
- **Excel** - color-coded risk scoring matrix with tier performance summary
- **Power BI** - 4-page interactive dashboard with conditional formatting heatmap

---

## Assumptions & Caveats

- Analysis uses the first 100,000 rows of the dataset - representative sample, not the full 2.2M row file
- Risk scoring thresholds derived from standard credit risk literature - not optimized against this specific dataset
- Grade G + Low Risk showing 0.00% default rate is based on 1 loan only - statistically meaningless, noted for transparency
- Higher observed conversion rate vs industry average should be interpreted directionally

---

## Recommendations

### Short-Term (Immediate Risk Controls)
- Flag all Grade G + High Risk loan applications for manual underwriting review before approval - this segment defaults at 62.04%
- Introduce a hard DTI cap at 30% for unsecured loans - borrowers above this threshold are disproportionately represented in Critical Risk
- Pause or reduce credit limits for existing High Risk borrowers showing revolving utilization above 75%

### Medium-Term (Portfolio Rebalancing)
- Shift origination targets toward Grade A and B borrowers in the Low and Medium Risk tiers - currently only 13.04% of the portfolio is Low Risk
- Reprice Small Business loans to reflect their 31.1% default rate - current interest rates do not adequately compensate for the risk
- Introduce income verification as a mandatory step for all loan purposes with default rates above 20% (Small Business, House, Medical, Moving, Debt Consolidation)

### Long-Term (Structural)
- Build a dynamic risk re-scoring system that updates borrower tier quarterly based on payment behavior, not just at origination - a Medium Risk borrower who misses two payments should be reclassified automatically
- Develop a debt consolidation specific underwriting framework - this is the highest volume purpose at 50K+ loans and a 22.49% default rate; a tailored assessment model would materially reduce portfolio default
- Replace the equal-tier scoring weights with regression-derived weights trained on this dataset - FICO and DTI currently carry 25% each based on literature; empirical weighting would improve tier separation accuracy


---

## Author

**Srujak Warbhuvan**  
[GitHub](https://github.com/Srujak-Warbhuvan) · [LinkedIn](https://linkedin.com/in/srujak-warbhuvan)
