# CORE: A Climate and Energy Integrated Risk Contribution Framework for the OECD and its Subgroups

## Overview

This repository contains the dataset and STATA Code used in the study:

**Pooja R., Sumanjay Dutta, and Parthajit Kayal (2026)**
*CORE: A Climate and Energy Integrated Risk Contribution Framework for the OECD and its Subgroups*
Published in *Structural Change and Economic Dynamics*.

The CORE framework develops a novel approach to measuring systemic financial risk by integrating climate, energy, and demographic factors across OECD countries and selected OECD subgroups.

---

## Dataset Coverage

* **Period:** January 2000 – December 2024
* **Frequency:** Monthly
* **Geographical Coverage:** OECD member countries
* **Subgroup Analysis:**

  * G7 Countries
  * Nordic Countries
  * Emerging OECD Economies

---

## Variables Included

### Climate Variables

* Mean Surface Air Temperature
* Precipitation

### Energy and Environmental Variables

* Primary Energy Consumption
* Electricity Generation
* Greenhouse Gas Emissions (GHG)

### Demographic Variable

* Population

### Risk Measures

* GDP-weighted Systemic Index
* Country-level Risk Contribution
* Delta Risk Contribution
* Energy Impact Factor (PCA-based)

---

## Data Construction

### GDP-Weighted Systemic Index

The systemic index for the OECD and each subgroup was constructed using country-level stock market indices weighted by annual GDP shares.

The index calculations were performed in Microsoft Excel. All formulas used in the construction of the GDP-weighted systemic indices are included within the workbook and can be traced directly. The calculation process is intended to be read alongside the methodology section of the published paper.

### Partial Correlation Adjustment

To isolate country-specific risk contribution effects, partial correlations between the broad OECD systemic index and individual country returns were calculated in Stata.

The resulting adjustments have been incorporated into the dataset and form part of the risk contribution measures used in the empirical analysis.

### Energy Impact Factor

To address multicollinearity among:

* Energy Consumption
* Electricity Generation
* Greenhouse Gas Emissions
* Population

Principal Component Analysis (PCA) was employed to construct a composite indicator termed the **Energy Impact Factor**, which is used throughout the econometric analysis.

---

## Replication Notes

The workbook contains:

* Raw and transformed variables
* GDP-weight calculations
* Systemic index calculations
* Risk contribution measures
* Intermediate calculations used in the study

Researchers can reproduce the index construction process directly from the formulas embedded within the workbook.

For complete methodological details, users should refer to the published article.

---

## Citation

If you use this dataset, please cite:

Pooja R., Dutta, S., & Kayal, P. (2026). *CORE: A Climate and Energy Integrated Risk Contribution Framework for the OECD and its Subgroups*. Structural Change and Economic Dynamics.

---



For questions regarding the dataset or methodology, please contact the corresponding authors through their institutional affiliations listed in the published article.
